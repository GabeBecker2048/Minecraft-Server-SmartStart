# Minecraft-Server-SmartStart
A simple windows batch script to automatically backup a Minecraft server on startup or shutdown
### No Plugins Required

Works with any server, vanilla, bukkit, or forge. 
Only works on Windows (Linux version possible in the future). 
Simple and easy to use!

## How to install:

1) Download a minecraft server jar file and run it for the first time 
   in an empty folder. Agree to the Eula, run the server again, then stop the server
   by typing "stop" (without the quotes) in the prompt.
   Skip this step if you already have a minecraft server
   
2) Create a new folder inside your server folder named "backups" (without the quotes)

3) Download the script files (start.bat, start_options.bat, and backup.bat)
   and add them to the folder where you keep your server files

4) Right click on "start_options.bat" and click "Edit" 
   NOTE: on Windows 11 you need to click "Show more options" then "Edit"

5) Adjust your settings as need. The default settings are:
   - MIN_RAM=1G
   - MAX_RAM=1G
   - SERVER_FILENAME=server.jar
   - BACKUP_ON_START=ON
   - BACKUP_ON_SHUTDOWN=OFF
   - MAX_BACKUPS=3
   - OVERRIDE_TODAYS_BACKUP=OFF
   - NUMBER_DAILY_BACKUPS=ON
   
   It is possible that your server jar file is not named server.jar. 
   If that is the case, you can either rename your jar file "server.jar" (without the quotes)
   or change the SERVER_FILENAME option to the name of the jar file.
   
   For more information on settings, look at the possible settings below

6) Any time you want to start the server, double click on start.bat. 
   If you only want to backup the server, double click on backup.bat

## Settings

#### MIN_RAM (Default 1G)
The minimum amount of RAM given to the server. 
This can be specified in gigabytes (with a G, e.g., 1G) or in megabytes (with a M, e.g., 1024M). 
It is recommended you leave this at 1G

#### MAX_RAM (Default 1G)
The maximum amount of RAM the server can use. 
This can be specified in gigabytes (with a G, e.g., 1G) or in megabytes (with a M, e.g., 1024M). 
You should not make this value larger than the amount of RAM on your computer. 
It is recommended you increase this number if plan on have many people on your server
or if you are running a modded server

#### SERVER_FILENAME (Default server.jar)
The name of the server jar file used to run the server. 
For start.bat to work this has to be your server jar file name

#### BACKUP_ON_START (Default ON)
Toggle for backing up the server on start up. 
This should always be either ON or OFF. 
If ON the server will create a backup in the backups folder when starting the server. 
If OFF the server will not create a backup on start up

#### BACKUP_ON_SHUTDOWN (Default OFF)
Toggle for backing up the server on shut down. 
This should always be either ON or OFF. 
If ON the server will create a backup in the backups folder when shuting down the server. 
If OFF the server will not create a backup on shut down

#### MAX_BACKUPS (Default 3)
The maximum number of backups allowed before the oldest backups are deleted. 
If this is set to -1 then your backups will never be deleted 

#### OVERRIDE_TODAYS_BACKUP (Default OFF)
If a backup has already been made today and this is ON, then the latest backup form today
will be overriden with a new backup. 
This should always be either ON or OFF. 
Leave this ON  to save the latest backup from every day. 
Leave this OFF to save multiple backups per day, or to save the oldest backup from every day

#### NUMBER_DAILY_BACKUPS (Default ON)
If OVERRIDE_TODAYS_BACKUP is OFF and this is ON, multiple backups can be saved per day. 
This option will only matter if OVERRIDE_TODAYS_BACKUP is OFF. 
This should always be either ON or OFF. 
Leave this ON to backup the server multiple times per day and save all backups. 
Laeve this OFF to only save the oldest backup from every day
