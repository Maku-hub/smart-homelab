#!/bin/bash

SCRIPT_DIR=$(pwd)
THIS_SCRIPT=$(basename "$0")
BACKUP_DIR=backups
CONTAINERS_DIR=docker-compose
MAN_TOOLS_DIR=manually_tools

PS3="What do you want?: "
date=$(date +"%Y%m%d")

MIKROTIK_ADDR="172.25.100.1"
MIKROTIK_USER=maku
MIKROTIK_URI="$MIKROTIK_USER@$MIKROTIK_ADDR"
BACKUP_MIKROTIK_FILENAME=backup_mikrotik
BACKUP_MIKROTIK_FILENAME_FULL="$BACKUP_MIKROTIK_FILENAME"_$date.backup

BACKUP_SRV01_FILENAME=backup_srv01
BACKUP_SRV01_FILENAME_FULL="$BACKUP_SRV01_FILENAME"_$date.tar.xz

select option in "Start containers" "Stop containers" "Backup srv01 (excluded file-browser files)" "Backup MikroTik" "Quit"
do
    case $option in
        "Start containers")
            cd "$SCRIPT_DIR"/"$CONTAINERS_DIR"/nginx
            docker compose --file $(basename "$PWD")-compose.yml up -d
            for d in "$SCRIPT_DIR"/"$CONTAINERS_DIR"/*/ ; do
                cd $d
                #if [ $(basename "$PWD") = "nginx" ]; then
                if [[ $(basename "$PWD") == "nginx" || $(basename "$PWD") == *___* ]]; then
                    continue
                else
                    docker compose --file $(basename "$PWD")-compose.yml up -d
                fi
            done
            echo "DONE!"
            break;;
        "Stop containers")
            cd $SCRIPT_DIR
            for d in "$SCRIPT_DIR"/"$CONTAINERS_DIR"/*/ ; do
                cd $d
                #if [ $(basename "$PWD") = "nginx" ]; then
                if [[ $(basename "$PWD") == "nginx" || $(basename "$PWD") == *___* ]]; then
                    continue
                else
                    docker compose --file $(basename "$PWD")-compose.yml down
                fi
            done
            cd "$SCRIPT_DIR"/"$CONTAINERS_DIR"/nginx
            docker compose --file $(basename "$PWD")-compose.yml down
            echo "DONE!"
            break;;
        "Backup MikroTik")
            cd $SCRIPT_DIR
            ssh $MIKROTIK_URI 'log info message="Backup to storage started";'
            ssh $MIKROTIK_URI "system backup save name=$BACKUP_MIKROTIK_FILENAME_FULL;"
            sftp $MIKROTIK_URI:$BACKUP_MIKROTIK_FILENAME_FULL
            mv $BACKUP_MIKROTIK_FILENAME_FULL "$SCRIPT_DIR"/"$BACKUP_DIR"/
            # Sleep needed as file might not be available for deletion right away
            sleep 3;
            ssh $MIKROTIK_URI "file remove $BACKUP_MIKROTIK_FILENAME_FULL;"
            ssh $MIKROTIK_URI 'log info message="Backup to storage completed"'
            # Check how many backup files are in the directory
            BACKUP_MIKROTIK_FILE_COUNT=$(ls -1 "$SCRIPT_DIR"/"$BACKUP_DIR"/"$BACKUP_MIKROTIK_FILENAME"_*.backup 2>/dev/null | wc -l)
            # If there are more than 2 backups, remove the oldest file
            if [ "$BACKUP_MIKROTIK_FILE_COUNT" -gt 2 ]; then
                # Find the oldest file and remove it
                OLDEST_BACKUP_MIKROTIK_FILE=$(ls -1t "$SCRIPT_DIR"/"$BACKUP_DIR"/"$BACKUP_MIKROTIK_FILENAME"_*.backup | tail -1)
                rm -rf "$OLDEST_BACKUP_MIKROTIK_FILE"
                echo "Removed oldest backup: $OLDEST_BACKUP_MIKROTIK_FILE"
            else
                echo "Backup count is within the limit: $BACKUP_MIKROTIK_FILE_COUNT files"
            fi
            echo "DONE!"
            break;;
        "Backup srv01 (excluded file-browser files)")
            cd $SCRIPT_DIR
            tar cJvf $BACKUP_SRV01_FILENAME_FULL --ignore-failed-read --exclude='file-browser/files' -C $SCRIPT_DIR $CONTAINERS_DIR $MAN_TOOLS_DIR $THIS_SCRIPT
            mv $BACKUP_SRV01_FILENAME_FULL "$SCRIPT_DIR"/"$BACKUP_DIR"/
            # Check how many backup files are in the directory
            BACKUP_FILE_COUNT=$(ls -1 "$SCRIPT_DIR"/"$BACKUP_DIR"/"$BACKUP_SRV01_FILENAME"_*.tar.xz 2>/dev/null | wc -l)
            # If there are more than 2 backups, remove the oldest file
            if [ "$BACKUP_FILE_COUNT" -gt 2 ]; then
                # Find the oldest file and remove it
                OLDEST_BACKUP_FILE=$(ls -1t "$SCRIPT_DIR"/"$BACKUP_DIR"/"$BACKUP_SRV01_FILENAME"_*.tar.xz | tail -1)
                rm -rf "$OLDEST_BACKUP_FILE"
                echo "Removed oldest backup: $OLDEST_BACKUP_FILE"
            else
                echo "Backup count is within the limit: $BACKUP_FILE_COUNT files"
            fi
            echo "DONE!"
            break;;
        "Quit")
            echo "We're done"
            break;;
        *)
            echo "Invalid option: $REPLY";;
    esac
done
