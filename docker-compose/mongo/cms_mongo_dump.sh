#!/bin/bash

source_path_daily=/home/cs2rel/backup/daily
source_path_weekly=/home/cs2rel/backup/weekly
current_date=$(date +%Y%m%d)
host=$1
port=27017
type=$2
typeSensitive=$(echo $type | tr [A-Z] [a-z])


echo "=========================================="
date
echo "> csdevopscms DB Backup start ${current_date}"

daily() {
        /usr/bin/mongodump --host ${host} --port ${port} --db csdevopscms --excludeCollection build_logs --gzip --archive=${source_path_daily}/${typeSensitive}.csdevopscms.mongo.${current_date}
        /usr/bin/mongodump --host ${host} --port ${port} --db admin --gzip --archive=${source_path_daily}/${typeSensitive}.admin.mongo.${current_date}
}

weekly() {
        /usr/bin/mongodump --host ${host} --port ${port} --gzip --archive=${source_path_weekly}/${typeSensitive}.cms.mongo.${current_date}
}


start() {
        if [ "daily" = "$typeSensitive" -o "weekly" = "$typeSensitive" ]; then
                if [ ! -d $source_path_daily ]; then
                        mkdir -p $source_path_daily
                fi
                if [ ! -d $source_path_weekly ]; then
                        mkdir -p $source_path_weekly
                fi
                if [ "daily" = "$typeSensitive" ]; then
                        daily
                elif [ "weekly" = "$typeSensitive" ]; then
                        weekly
                fi
        else
                echo "usage : $0 [hostname] [daily|weekly]"
                exit 0
        fi
}

execute() {
        start
        if [ $? -eq 0 ]; then
                echo "> csdevopscms DB backup successfully at $current_date"
        else
                echo "> csdevopscms DB backup failure at $current_date"
        fi
}

housekeep() {
        echo "> Start to housekeep"
        if [ $typeSensitive = "daily" ]; then
                find $source_path_daily -type f -mtime 7 -exec rm -f {} \;
        fi
        if [ $typeSensitive = "weekly" ]; then
                find $source_path_weekly -type f -mtime 7 -exec rm -rf  {} \;
        fi
        echo "> End housekeep"
}

execute
housekeep

date
echo "=========================================="
echo