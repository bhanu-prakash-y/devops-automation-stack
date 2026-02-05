#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
script_dir=$pwd
mongodb_host=$mongodb.bhanudevops.online


if [ $USERID -ne 0 ]; then
    echo  "please run this script root acccess" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
         echo "$2 ... FAILURE" | tee -a $LOGS_FILE
         exit 1
    else    
      echo  "$2 ... SUCCESS"    | tee -a $LOGS_FILE
    fi 
}



dnf module disable nodejs -y &>>$LOGS_FILE
VALIDATE $? "Disabling NodeJS Default Version"

dnf module enable nodejs:20 -y &>>$LOGS_FILE
VALIDATE $? "Enable NodeJS"

dnf install nodejs -y &>>$LOGS_FILE
VALIDATE $? "Install NodeJS"

id roboshop  &>>$LOGS_FILE
if [ $? -ne 0 ]; then 
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop  &>>$LOGS_FILE
    VALIDATE $? "Creating user"
else 
     echo "Roboshop user already exit ...... SKIPPING"
fi     

mkdir -p /app 
VALIDATE $? "Creating app dir"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip  &>>$LOGS_FILE
VALIDATE $? "Downloading catalgoue code"

cd /app 
VALIDATE $? "moving to app directory"

rm -rf /app/*
VALIDATE $? "remove the exit code"

unzip /tmp/catalogue.zip
VALIDATE $? "Unzip catalogue code"


npm install 
VALIDATE $? "Installing dependencie"

cp $script_dir/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "create systemctl service"

systemctl daemon-reload
systemctl enable catalogue 
systemctl start catalogue
VALIDATE $? "starting and enabling catalogue"

cp  $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y


mongosh --host $mongodb_host </app/db/master-data.js