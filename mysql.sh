#!/bin/bash
# common.sh file is sourced to use the common functions and variables defined in it.
source ./common.sh

# checking for root user access.
check_root
# installing mysql.
echo "Setting up MySQL Repository"
dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "Install MySQL server"

systemctl enable mysqld &>>$LOGS_FILE
systemctl start mysqld  
VALIDATE $? "Enable and start mysql"

# get the password from user
mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setup root password"

print_total_time 