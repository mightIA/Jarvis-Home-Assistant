@echo off
REM === Run BlocA - Audit S68 ===
REM Lance le script PowerShell read-only et redirige toute la sortie vers BlocA.txt
REM Aucune modification systeme appliquee.

set "SCRIPT=%~dp0BlocA_Windows_Defender_Firewall.ps1"
set "OUTDIR=%~dp0..\outputs_powershell"
set "OUTFILE=%OUTDIR%\BlocA.txt"

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

echo.
echo === Audit S68 - Bloc A (systeme + Defender + firewall) ===
echo Script  : %SCRIPT%
echo Output  : %OUTFILE%
echo.
echo Execution en cours, patiente ~30-60 secondes...
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
