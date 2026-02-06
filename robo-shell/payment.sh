#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
script_dir=$PWD
mysql_host=mysql.bhanudevops.online


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

dnf install python3 gcc python3-devel -y &>>$LOGS_FILE
VALIDATE $? "Installing python"

id roboshop  &>>$LOGS_FILE
if [ $? -ne 0 ]; then 
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop  &>>$LOGS_FILE
    VALIDATE $? "Creating user"
else 
     echo "Roboshop user already exit ... SKIPPING"
fi     

mkdir -p /app 
VALIDATE $? "Creating app dir"

curl -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip  &>>$LOGS_FILE
VALIDATE $? "Downloading payment code"

cd /app 
VALIDATE $? "moving to app directory"

rm -rf /app/*
VALIDATE $? "remove the exit code"

unzip /tmp/payment.zip &>>$LOGS_FILE
VALIDATE $? "Unzip payment code"


cd /app 
pip3 install -r requirements.txt &>>$LOGS_FILE
VALIDATE $? "installing requirement"


cp $script_dir/payment.service /etc/systemd/system/payment.service
VALIDATE $? "created systemctl service"

systemctl daemon-reload
systemctl enable payment 
systemctl start payment
VALIDATE $? "enable and start payment"