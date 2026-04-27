@echo off
REM === Run BlocBC Admin - Audit S68 ===
REM Necessite : clic droit -> Executer en tant qu'administrateur
REM Lecture seule. Aucun contenu de secret n'est ecrit dans l'output (Regle 0).

set "SCRIPT=%~dp0BlocBC_Admin.ps1"
set "OUTDIR=%~dp0..\outputs_powershell"
set "OUTFILE=%OUTDIR%\BlocBC.txt"

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

REM Verifier privileges admin (net session est admin-only)
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [!] Ce script doit etre lance EN ADMIN.
    echo [!] Ferme cette fenetre, fais un CLIC DROIT sur Run_BlocBC_Admin.cmd
    echo [!] et choisis "Executer en tant qu'administrateur".
    echo.
    pause
    exit /b 1
)

echo.
echo === Audit S68 - Bloc B + C admin (user folder + WSL2 + BitLocker + Defender exclusions + winget + autostart + RDP/SMB) ===
echo Script  : %SCRIPT%
echo Output  : %OUTFILE%
echo.
echo Execution en cours, patiente ~1-2 minutes (winget est lent au premier appel)...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" > "%OUTFILE%" 2>&1

if %ERRORLEVEL% EQU 0 (
    echo.
    echo === Termine. Output dans : %OUTFILE% ===
) else (
    echo.
    echo === Erreur lors de l'execution. ErrorLevel : %ERRORLEVEL% ===
    echo Verifie %OUTFILE% pour le detail.
)

echo.
pause
