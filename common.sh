#!/bin/bash

# Validate whether the root user is executing the script or not.
USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log" # /var/log/shell-roboshop/mongodb.sh.log

# color codes given for outpit messages.
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
START_TIME=$(date +%s)

mkdir -p $LOGS_FOLDER # create log folder if not exists.

#date and time of script execution.
echo "$(date "+%Y-%m-%d %H:%M:%S") | Script started executing at: $(date)" | tee -a $LOGS_FILE
# check for root user.
check_root(){
    if [ $USERID -ne 0 ]; then
        echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
        exit 1
    fi
}

# function to validate each command execution status.
VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $R FAILURE $N" | tee -a $LOGS_FILE # append the log file.
        exit 1 # exit without failure status.
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
    # total time taken for script execution.
}
print_total_time(){
    END_TIME=$(date +%s)
    TOTAL-TIME=$((END_TIME-START_TIME))
    echo -e  "$(date "+%Y-%m-%d %H:%M:%S") | Script execute in: $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE
}

