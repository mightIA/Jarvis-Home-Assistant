@echo off
REM jarvis-cli.bat
REM Double-cliquable pour lancer Claude Code CLI dans le dossier projet Jarvis.
REM Appelle le script PowerShell jarvis-cli.ps1.
REM Creation : session 27 (22/04/2026)

powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0jarvis-cli.ps1"

REM Ne pas fermer la fenetre automatiquement si erreur
if errorlevel 1 pause
