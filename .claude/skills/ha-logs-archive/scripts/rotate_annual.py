#!/usr/bin/env python3
"""
rotate_annual.py — Rotation annuelle des logs HA archivés.

Zippe les 12 dossiers mensuels Archives/ha_logs/AAAA-MM/ d'une année donnée
dans Archives/ha_logs/ha_logs_AAAA.zip, vérifie l'intégrité, puis supprime
les dossiers mensuels d'origine UNIQUEMENT si la vérif passe.

Usage :
    python rotate_annual.py --year 2025
    python rotate_annual.py --year 2025 --dry-run
    python rotate_annual.py --year 2025 --keep-monthly  # zip mais pas suppr.

Skill : ha-logs-archive (T#34)
Créé S87 (mai 2026)
"""

from __future__ import annotations

import argparse
import shutil
import sys
import zipfile
from pathlib import Path


def find_project_root() -> Path:
    """Trouve la racine projet Jarvis - Home Assistant."""
    # 1) Essai : cwd contient Archives/ha_logs/
    cwd = Path.cwd()
    if (cwd / "Archives" / "ha_logs").is_dir():
        return cwd
    # 2) Remonter depuis le dossier du script
    here = Path(__file__).resolve()
    for parent in here.parents:
        if (parent / "Archives" / "ha_logs").is_dir():
            return parent
        if (parent / "CLAUDE.md").is_file() and parent.name.startswith("Jarvis"):
            return parent
    sys.exit("[rotate_annual] ERREUR : racine projet introuvable. "
             "Lancer depuis le dossier projet ou via path absolu.")


def list_monthly_dirs(root: Path, year: int) -> list[Path]:
    """Liste les dossiers Archives/ha_logs/AAAA-MM/ pour l'année donnée."""
    base = root / "Archives" / "ha_logs"
    if not base.is_dir():
        sys.exit(f"[rotate_annual] ERREUR : {base} n'existe pas.")
    pattern = f"{year}-"
    monthly = sorted(
        d for d in base.iterdir()
        if d.is_dir() and d.name.startswith(pattern) and len(d.name) == 7
    )
    return monthly


def count_files(monthly_dirs: list[Path]) -> int:
    """Compte total fichiers dans tous les dossiers mensuels."""
    return sum(
        1
        for d in monthly_dirs
        for _ in d.rglob("*")
        if _.is_file()
    )


def total_size(monthly_dirs: list[Path]) -> int:
    """Taille totale en bytes."""
    return sum(
        f.stat().st_size
        for d in monthly_dirs
        for f in d.rglob("*")
        if f.is_file()
    )


def create_zip(monthly_dirs: list[Path], zip_path: Path) -> None:
    """Crée un zip ZIP_DEFLATED contenant tous les dossiers mensuels."""
    print(f"[rotate_annual] Création {zip_path.name}…")
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for d in monthly_dirs:
            for f in d.rglob("*"):
                if f.is_file():
                    arcname = f.relative_to(d.parent)  # garde Archives/ha_logs/AAAA-MM/file
                    zf.write(f, arcname)
    print(f"[rotate_annual]   {zip_path.stat().st_size / 1024 / 1024:.2f} MB écrits")


def verify_zip(zip_path: Path, expected_files: int) -> bool:
    """Vérifie le zip : intégrité CRC + nb fichiers attendu."""
    print(f"[rotate_annual] Vérification {zip_path.name}…")
    try:
        with zipfile.ZipFile(zip_path, "r") as zf:
            bad = zf.testzip()
            if bad is not None:
                print(f"[rotate_annual]   ÉCHEC CRC sur {bad}")
                return False
            actual = len(zf.namelist())
            if actual != expected_files:
                print(f"[rotate_annual]   ÉCHEC nb fichiers : {actual} ≠ {expected_files}")
                return False
        print(f"[rotate_annual]   OK : CRC valide, {expected_files} fichiers")
        return True
    except zipfile.BadZipFile as e:
        print(f"[rotate_annual]   ÉCHEC zip corrompu : {e}")
        return False


def remove_monthly_dirs(monthly_dirs: list[Path]) -> None:
    """Supprime les dossiers mensuels après vérif OK."""
    for d in monthly_dirs:
        print(f"[rotate_annual] Suppression {d.name}/")
        shutil.rmtree(d)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--year", type=int, required=True,
                        help="Année à archiver (ex 2025)")
    parser.add_argument("--dry-run", action="store_true",
                        help="Affiche ce qui serait fait sans rien écrire")
    parser.add_argument("--keep-monthly", action="store_true",
                        help="Zippe mais conserve les dossiers mensuels (pas de purge)")
    args = parser.parse_args()

    root = find_project_root()
    print(f"[rotate_annual] Racine projet : {root}")

    monthly_dirs = list_monthly_dirs(root, args.year)
    if not monthly_dirs:
        print(f"[rotate_annual] Aucun dossier {args.year}-* trouvé. Rien à faire.")
        return 0

    nb_files = count_files(monthly_dirs)
    size_mb = total_size(monthly_dirs) / 1024 / 1024
    print(f"[rotate_annual] {len(monthly_dirs)} dossiers mensuels, "
          f"{nb_files} fichiers, {size_mb:.2f} MB total")
    for d in monthly_dirs:
        print(f"  - {d.name}")

    zip_path = root / "Archives" / "ha_logs" / f"ha_logs_{args.year}.zip"
    if zip_path.exists():
        print(f"[rotate_annual] ATTENTION : {zip_path.name} existe déjà.")
        if not args.dry_run:
            backup = zip_path.with_suffix(".zip.previous")
            print(f"[rotate_annual]   sauvegarde vers {backup.name}")
            shutil.move(zip_path, backup)

    if args.dry_run:
        print(f"[rotate_annual] DRY-RUN — créerait {zip_path}")
        print(f"[rotate_annual] DRY-RUN — supprimerait {len(monthly_dirs)} dossiers")
        return 0

    create_zip(monthly_dirs, zip_path)

    if not verify_zip(zip_path, nb_files):
        print("[rotate_annual] ÉCHEC vérification zip → "
              "dossiers mensuels CONSERVÉS pour debug.")
        return 1

    if args.keep_monthly:
        print("[rotate_annual] --keep-monthly : dossiers mensuels conservés.")
        ratio = (1 - zip_path.stat().st_size / total_size(monthly_dirs)) * 100
        print(f"[rotate_annual] Ratio compression : {ratio:.1f}%")
        return 0

    remove_monthly_dirs(monthly_dirs)

    final_zip_size = zip_path.stat().st_size / 1024 / 1024
    ratio = (1 - zip_path.stat().st_size / (size_mb * 1024 * 1024)) * 100
    print(f"[rotate_annual] OK — {zip_path.name} = {final_zip_size:.2f} MB "
          f"(ratio compression : {ratio:.1f}%)")
    print(f"[rotate_annual] {len(monthly_dirs)} dossiers mensuels supprimés.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
