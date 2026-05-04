@echo off
REM ============================================================
REM  ha_logs_archive_run.bat
REM  Invoque par la scheduled task Jarvis-HA-Logs-Archive-Quotidien
REM  chaque jour a 02h00 sur Might-1000D.
REM  Source : .claude/skills/ha-logs-archive/SKILL.md (v2 - S91)
REM ============================================================

cd /d "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant"

REM Construire le timestamp pour le log d'execution (format AAAA-MM-JJ_HH-MM)
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value ^| find "="') do set DT=%%a
set TS=%DT:~0,4%-%DT:~4,2%-%DT:~6,2%_%DT:~8,2%-%DT:~10,2%

REM Creer dossier _run_logs si absent
if not exist "Archives\ha_logs\_run_logs" mkdir "Archives\ha_logs\_run_logs"

REM Chemin absolu vers claude.exe (S95 - schtasks PATH restreint)
set CLAUDE_EXE=C:\Users\Might\.local\bin\claude.exe

REM Logfile cible
set LOGFILE=Archives\ha_logs\_run_logs\run_%TS%.txt

REM Diag pre-flight : confirmer que tout est OK avant de lancer claude
echo === ha_logs_archive_run.bat - %TS% === >> "%LOGFILE%"
echo CWD: %CD% >> "%LOGFILE%"
echo USERNAME: %USERNAME% >> "%LOGFILE%"
echo CLAUDE_EXE: %CLAUDE_EXE% >> "%LOGFILE%"
if exist "%CLAUDE_EXE%" (
    echo CLAUDE_EXE: PRESENT >> "%LOGFILE%"
) else (
    echo CLAUDE_EXE: ABSENT - check install path >> "%LOGFILE%"
    exit /b 1
)
echo --- claude --version --- >> "%LOGFILE%"
"%CLAUDE_EXE%" --version >> "%LOGFILE%" 2>&1
echo --- DEBUT execution skill --- >> "%LOGFILE%"

REM Lancer claude CLI headless avec la skill ha-logs-archive
REM Prompt durci S95 (T#34 piste a/b) :
REM  - Mode non-interactif (.bat n'a pas de stdin pour repondre aux questions)
REM  - Si dossier du jour existe, le completer sans demander
REM  - Pas de fallback iPhone, tout passe par MCP HA
REM --dangerously-skip-permissions : indispensable en contexte scheduled task
REM (le .bat n'a pas de UI pour valider les approbations MCP/file write).
REM Risque maitrise : skill predefinie en lecture seule cote HA (ha_get_logs)
REM + ecriture limitee a Archives/ha_logs/ (cf. patch .gitignore S95).
"%CLAUDE_EXE%" --dangerously-skip-permissions -p "Execute la skill ha-logs-archive en mode quotidien automatique pour archiver les 24h precedentes. Comportement par defaut requis : si le dossier Archives/ha_logs/AAAA-MM-JJ du jour existe deja, complete-le sans poser de question (overwrite des 3 fichiers raw_logbook + raw_system_errors + consolide). Aucune confirmation interactive requise, mode headless pur." >> "%LOGFILE%" 2>&1

set RC=%ERRORLEVEL%
echo --- FIN execution skill (exit code %RC%) --- >> "%LOGFILE%"
exit /b %RC%
