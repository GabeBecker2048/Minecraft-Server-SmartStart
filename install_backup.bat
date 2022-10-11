@echo off
setlocal EnableDelayedExpansion

:: gets last backup
cd ./backups
set /a num=0
set /a day=0
set /a month=0
set /a year=0
for /d %%G in (world_backup_*-*-*) do (
	set "i=%%G"
	
	set iyear_str=!i:~13,2!
	if "!iyear_str:~0,1!"=="0" set iyear_str=!iyear_str:~1,1!
	set /a iyear=iyear_str
	
	set imonth_str=!i:~16,2!
	if "!imonth_str:~0,1!"=="0" set imonth_str=!imonth_str:~1,1!
	set /a imonth=imonth_str
		
	set iday_str=!i:~19,2!
	if "!iday_str:~0,1!"=="0" set iday_str=!iday_str:~1,1!
	set /a iday=iday_str
	
	
	call :strLen !i!
	set /a inum=0
	if !len! gtr 21 set /a inum=!i:~22!
	if !iyear! gtr !year! call :swapdates else \
	if !iyear! equ !year! if !imonth! gtr !month! call :swapdates else \
	if !iyear! equ !year! if !imonth! equ !month! if !iday! gtr !day! call :swapdates else \
	if !iyear! equ !year! if !imonth! equ !month! if !iday! equ !day! if !inum! gtr !num! call :swapdates
)
cd ..

:: string formatting
call :strLen !year!
if not !len! equ 2 set year=0!year!
call :strLen !month!
if not !len! equ 2 set month=0!month!
call :strLen !day!
if not !day! equ 2 set day=0!day!
if !num! equ 0 (set newest_backup=world_backup_!year!-!month!-!day!) else (set newest_backup=world_backup_!year!-!month!-!day!-!num!)

:: warning
echo Continuing will do the following:
echo 	- save your current world as world_old
echo 	- replace your current world with the latest backup (%newest_backup%)
choice /m "Do you wish to continue "
if errorlevel ==2 echo Aborted & exit /b

:: finishes
robocopy ./world ./world_old
robocopy ./backups/%newest_backup% ./world

echo Backup restored. 

endlocal
exit /b


:strLen
if "%2"=="" set /a len=0
set "istr=%1"
set substr="!istr:~%len%!"
if not %substr%=="" set /a len+=1 & call :strLen %1 %len%
exit /b

:swapdates
set /a year=!iyear!
set /a month=!imonth!
set /a day=!iday!
set /a num=!inum!
exit /b
