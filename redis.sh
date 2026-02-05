#!/bin/bash
# common.sh file is sourced to use the common functions and variables defined in it.
source ./common.sh

# checking for root user access.
check_root
# installing redis.
echo "Setting up Redis Repository"
dnf module disable redis -y &>>$LOGS_FILE
dnf module enable redis:7 -y &>>$LOGS_FILE
VALIDATE $? "Enable Redis:7"

dnf install redis -y  &>>$LOGS_FILE
VALIDATE $? "Installed Redis"
# configuring redis to allow remote connections.
sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allowing remote connections"

systemctl enable redis &>>$LOGS_FILE
systemctl start redis 
VALIDATE $? "Enabled and started Redis"
print_total_time