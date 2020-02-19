#!/bin/sh
# Take dataBase dumb from container 
# crontab ==> 00 20 * * * /home/novell/databaseBackupScript.sh
now="$(date +'%d_%m_%Y_%H_%M_%S')"
filename="db_backup_$now".gz
backupfolder="./backup"
fullpathbackupfile="$backupfolder/$filename"
logfile="$backupfolder/"backup_log_"$(date +'%Y_%m')".txt
echo "mysqldump started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
docker exec -it accpharmadb mysqldump -u root -prootpassword accpharma | gzip > "$fullpathbackupfile"
echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
chmod 777 "$fullpathbackupfile"
chmod 777 "$logfile"
echo "file permission changed" >> "$logfile"
find "$backupfolder" -name db_backup_\* -mtime +30 -exec rm {} \;
echo "old files removed" >> "$logfile"
rsync -arv "$backupfolder" backup@35.202.213.35:/home/backup --delete
echo "synced with staging server"
echo "operation finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"
exit 0

