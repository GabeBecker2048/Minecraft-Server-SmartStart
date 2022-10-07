@echo off
call start_options.bat
if %BACKUP_ON_START%==ON call backup.bat
echo Starting server now... & echo.
java -Xmx%MAX_RAM% -Xms%MIN_RAM% -jar %SERVER_FILENAME%