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
SCRIPT_DIR=$PWD
START_TIME=$(date +%s)
MONGODB_HOST=mongodb.divakar88.online

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
}
    # total time taken for script execution.
    nodejs_setup(){
        echo "Setting up NodeJS"
        dnf module disable nodejs -y &>>$LOGS_FILE
        VALIDATE $? "Disabling NodeJS Default version"

        dnf module enable nodejs:20 -y &>>$LOGS_FILE
        VALIDATE $? "Enabling NodeJS 20"

         dnf install nodejs -y &>>$LOGS_FILE
        VALIDATE $? "Install NodeJS"

        npm install  &>>$LOGS_FILE
        VALIDATE $? "Installing dependencies"

    }
# function to setup application.
app_setup(){
    id roboshop &>>$LOGS_FILE
     if [ $? -ne 0 ]; then
     useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
     VALIDATE $? "Creating system user"
else
    echo -e "Roboshop user already exist ... $Y SKIPPING $N"
fi
        mkdir -p /app 
    VALIDATE $? "Creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>>$LOGS_FILE
    VALIDATE $? "Downloading $app_name code"

     cd /app
    VALIDATE $? "Moving to app directory"

    rm -rf /app/*
    VALIDATE $? "Removing existing code"

    unzip /tmp/$app_name.zip &>>$LOGS_FILE
    VALIDATE $? "Uzip $app_name code"
}
# function to setup systemd service.
systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
VALIDATE $? "Created systemctl service"

systemctl daemon-reload
systemctl enable $app_name  &>>$LOGS_FILE
systemctl start $app_name
VALIDATE $? "Starting and enabling $app_name"
}
# function to restart application.
app_restart(){
    systemctl restart $app_name
    VALIDATE $? "Restarting $app_name"
}
# function to print total time taken for script execution.
print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$((END_TIME-START_TIME))
    echo -e  "$(date "+%Y-%m-%d %H:%M:%S") | Script execute in: $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE
}

