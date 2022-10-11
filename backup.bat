@echo off
call start_options.bat
set month=%DATE:~4,2%
set day=%DATE:~7,2%
set year=%DATE:~12,2%
setlocal EnableDelayedExpansion

echo ----------------------------------------
echo    Minecraft server world backup tool
echo ---------------------------------------- & echo.
 
:: tests if (and how many times) we have already backed up the world today
cd ./backups
set saved_today=FALSE
set /a backupnum=-1
for /d %%G in (world_backup_%year%-%month%-%day%*) do (
	set "i=%%G"
	set /a curnum=0
	call :strLen !i!
	if !len! gtr 21 set curnum=!i:~22!
	if !curnum! gtr !backupnum! set /a backupnum=!curnum!
)
if !backupnum! neq -1 set saved_today=TRUE
set /a backupnum+=1

:: detects backups
set /a count=0
for /d %%G in (world_backup_*-*-*) do set /a count+=1
echo Found %count% backup(s)
cd ..

:: saves the backup
if !saved_today!==FALSE robocopy ./world ./backups/world_backup_%year%-%month%-%day% /E & set /a count+=1 & echo Created backup world_backup_%year%-%month%-%day% & echo.
if !saved_today!==TRUE (
	if %OVERRIDE_TODAYS_BACKUP%==ON robocopy ./world ./backups/world_backup_%year%-%month%-%day% /E & echo Updated backup world_backup_%year%-%month%-%day% & echo.
	if %OVERRIDE_TODAYS_BACKUP%==OFF if %NUMBER_DAILY_BACKUPS%==ON robocopy ./world ./backups/world_backup_%year%-%month%-%day%-!backupnum! /E & set /a count+=1 & echo Created backup world_backup_%year%-%month%-%day%-!backupnum! & echo.
	if %OVERRIDE_TODAYS_BACKUP%==OFF if %NUMBER_DAILY_BACKUPS%==OFF echo Because a backup has already been created today, nothing was saved 
)

:: cleans up any unwanted backups
if %MAX_BACKUPS% neq -1 echo Cleaning backups... & echo. & call :clean

endlocal
echo Backup completed & echo.
if not defined startFlag echo Press any key to exit... & pause>nul
if %BACKUP_ON_SHUTDOWN%==ON echo Press any key to exit... & pause>nul
exit /b


:clean

if !count! leq %MAX_BACKUPS% echo. & echo Cleaning complete & exit /b

:: gets oldest backup
cd ./backups
set /a num=2048
set /a day=32
set /a month=13
set /a year=100
for /d %%G in (world_backup_*-*-*) do (
	set "i=%%G"
	
	set iyear_str=!i:~13,2!
	if "!iyear_str:~0,1!"=="0" set iyear_str=!iyear_str:~1,1!
	set /a iyear=!iyear_str!
	
	set imonth_str=!i:~16,2!
	if "!imonth_str:~0,1!"=="0" set imonth_str=!imonth_str:~1,1!
	set /a imonth=!imonth_str!
		
	set iday_str=!i:~19,2!
	if "!iday_str:~0,1!"=="0" set iday_str=!iday_str:~1,1!
	set /a iday=!iday_str!
	
	
	call :strLen !i!
	set /a inum=0
	if !len! gtr 21 set /a inum=!i:~22!
	if !iyear! lss !year! call :swapdates else \
	if !iyear! equ !year! if !imonth! lss !month! call :swapdates else \
	if !iyear! equ !year! if !imonth! equ !month! if !iday! lss !day! call :swapdates else \
	if !iyear! equ !year! if !imonth! equ !month! if !iday! equ !day! if !inum! lss !num! call :swapdates
)
cd ..

:: string formatting
call :strLen !year!
if !len! neq 2 set year=0!year!
call :strLen !month!
if !len! neq 2 set month=0!month!
call :strLen !day!
if !len! neq 2 set day=0!day!
if !num! equ 0 (set oldest_backup=world_backup_!year!-!month!-!day!) else (set oldest_backup=world_backup_!year!-!month!-!day!-!num!)

:: removes the backup
rmdir .\backups\%oldest_backup% /s /q & set /a count-=1 & echo Removed backup %oldest_backup%. There are now !count! backups remaining & call :clean

exit /b


:swapdates
set /a year=!iyear!
set /a month=!imonth!
set /a day=!iday!
set /a num=!inum!
exit /b

:strLen
if "%2"=="" set /a len=0
set "istr=%1"
set substr="!istr:~%len%!"
if not %substr%=="" set /a len+=1 & call :strLen %1 %len%
exit /b