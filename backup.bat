@echo off
call start_options.bat
set month=%DATE:~4,2%
set day=%DATE:~7,2%
set year=%DATE:~12,2%
setlocal EnableDelayedExpansion
 
:: tests if we have already backed up the world today
cd ./backups
set saved_today=FALSE
for /d %%G in (world_backup_*-*-*) do (
	set "i=%%G"
	set iyear=!i:~13,2!
	set imonth=!i:~16,2!
	set iday=!i:~19,2!
	if %year%==!iyear! if %month%==!imonth! if %day%==!iday! set saved_today=TRUE
)

:: gets the backupnumber
set /a backupnum=0
for /d %%G in (world_backup_%year%-%month%-%day%-*) do (
	set "i=%%G"
	set /a curnum=!i:~22!
	if !curnum! gtr !backupnum! set /a backupnum=!curnum!
)
set /a backupnum+=1

:: detects backups
set /a count=0
for /d %%G in (world_backup_*-*-*) do set /a count+=1
echo Found !count! backup(s)

:: cleans up any unwanted backups
if !count! gtr %MAX_BACKUPS% if  not %MAX_BACKUPS% equ -1 call :cleanbackups
cd ..

:: saves the backup
if %saved_today%==FALSE robocopy ./world ./backups/world_backup_%year%-%month%-%day% /E
if %saved_today%==TRUE (
	if %OVERRIDE_TODAYS_BACKUP%==ON robocopy ./world ./backups/world_backup_%year%-%month%-%day% /E
	if %OVERRIDE_TODAYS_BACKUP%==OFF if %NUMBER_DAILY_BACKUPS%==ON robocopy ./world ./backups/world_backup_%year%-%month%-%day%-!backupnum! /E
)

endlocal
echo. & echo Backup completed
exit /b


:cleanbackups
set nextdir=""
for /d %%G in (world_backup_*-*-*) do (
	set "i=%%G"
	set iyear=!i:~13,2!
	set imonth=!i:~16,2!
	set iday=!i:~19,2!
	set /a strlen=0
	call :strLen
	if !strlen! equ 21 set nextdir=%%G
	if !nextdir!=="" call :findnextdir
)
if !count! gtr %MAX_BACKUPS% rmdir !nextdir! /s /q & set /a count-=1 & echo Deleted backup !nextdir!. There are now !count! remaining backup(s)
if !count! gtr %MAX_BACKUPS% call :cleanbackups
exit /b

:findnextdir
set /a minnum=2048
for /d %%F in (world_backup_!iyear!-!imonth!-!iday!-*) do (
	set "j=%%F"
	set /a curnum=!j:~22!
	if !curnum! lss !minnum! set /a minnum=!curnum! & set nextdir=%%F
)
if !minnum! equ 2048 set nextdir=%%G
exit /b

:strLen
set substr="!i:~%strlen%!"
if not %substr%=="" set /a strlen+=1 & call :strLen
exit /b