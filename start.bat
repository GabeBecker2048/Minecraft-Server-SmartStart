@echo off
set /a startFlag=1
call start_options.bat
if %BACKUP_ON_START%==ON call backup.bat
echo Starting server now... & echo.
java -Xmx%MAX_RAM% -Xms%MIN_RAM% -jar %SERVER_FILENAME%
if %BACKUP_ON_SHUTDOWN%==ON call backup.bat