@echo off
:: 					Start settings

:: maximum amount of RAM given to the server
set MIN_RAM=1G	

:: minimum amount of RAM given to the server
set MAX_RAM=1G

:: the name of the server file
set SERVER_FILENAME=server.jar

:: if ON creates a backup of the server before startup
set BACKUP_ON_START=ON		

:: 					Backup settings

:: maximum number of backups saved before the oldest backup(s) get deleted
:: if set to -1 then backups will never be deleted (DOES NOT WORK YET)
set /a MAX_BACKUPS=3

:: if ON and if a backup has already been created today
::		the backup for the current date will be overriden
:: if OFF, prefences are defaulted to NUMBER_DAILY_BACKUPS
set OVERRIDE_TODAYS_BACKUP=OFF


:: if ON a new backup will be created every time the server starts.
::		Backups will be saved as "world_backup_YY-MM-DD-N"
:: 		where N is the Nth backup on that date

:: if OFF a new backup will not be created until a day has passed from the latest backup
:: 		Backups will be saved as "world_backup_YY-MM-DD"

:: NOTE: this setting will not matter unless OVERRIDE_TODAYS_BACKUP is OFF
set NUMBER_DAILY_BACKUPS=ON
