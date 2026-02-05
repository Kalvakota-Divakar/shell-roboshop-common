#!/bin/bash
# common.sh file is sourced to use the common functions and variables defined in it.
source ./common.sh
app_name=catalogue
# checking for root user access.
check_root
app_setup
nodejs_setup
systemd_setup
# loading products data into mongodb database.
cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOGS_FILE

INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
# check whether catalogue db is present or not.
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js
    VALIDATE $? "Loading products"
else
    echo -e"$(date "+%Y-%m-%d %H:%M:%S") | Products already loaded ... $Y SKIPPING $N"
fi
