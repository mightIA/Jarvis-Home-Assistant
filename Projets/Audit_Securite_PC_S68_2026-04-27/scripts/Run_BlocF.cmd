@echo off
REM === Run BlocF (DNS énumération might.ovh + HIBP 4 boîtes) - Audit S68 ===
REM Pas besoin d'admin. Juste un PC connecté à Internet.
REM Lecture seule. Aucune modification.

set "SCRIPT=%~dp0BlocF_DNS_HIBP.ps1"
set "OUTDIR=%~dp0..\outputs_powershell"
set "OUTFILE=%OUTDIR%\BlocF.txt"

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

echo.
echo === Audit S68 - Bloc F (DNS might.ovh + HIBP 4 boites email) ===
echo Script  : %SCRIPT%
echo Output  : %OUTFILE%
echo.
echo Execution en cours, patiente ~1-2 minutes (DNS brute force + HIBP rate limit)...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" > "%OUTFILE%" 2>&1

if %ERRORLEVEL% EQU 0 (
    echo.
    echo === Termine. Output dans : %OUTFILE% ===
) else (
    echo.
    echo === Erreur lors de l'execution. ErrorLevel : %ERRORLEVEL% ===
)

echo.
pause
