#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
script_dir=$PWD
mysqldb_host=mysql.bhanudevops.online


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

dnf update -y openssh openssh-server openssh-clients &>>$LOGS_FILE
VALIDATE $? "update openssh"

id roboshop  &>>$LOGS_FILE
if [ $? -ne 0 ]; then 
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop  &>>$LOGS_FILE
    VALIDATE $? "Creating user"
else 
     echo " user already exit ... SKIPPING"
fi     

mkdir -p /app 
VALIDATE $? "Creating app dir"

curl -o /tmp/backend.zip https://expense-joindevops.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGS_FILE
VALIDATE $? "Downloading user code"

cd /app 
VALIDATE $? "moving to app directory"

rm -rf /app/*
VALIDATE $? "remove the exit code"

unzip /tmp/backend.zip &>>$LOGS_FILE
VALIDATE $? "Unzip user code"


npm install  &>>$LOGS_FILE
VALIDATE $? "Installing dependencies"

cp $script_dir/backend.service /etc/systemd/system/backend.service
VALIDATE $? "created systemctl service"

systemctl daemon-reload
systemctl start backend 
systemctl enable backend
VALIDATE $? "starting and enabling backend"


dnf install mysql -y
VALIDATE $? "installing"

mysql -h $mysqldb_host -uroot -pExpenseApp@1 < /app/schema/backend.sql

if [ $? -ne 0 ]; then

     mysql -h $mysqldb_host -uroot -pExpenseApp@1 < /app/schema/backend.sql

    VALIDATE $? "my sql"

else 
   echo "data is already loaded"
fi    



systemctl restart backend
VALIDATE $? "restart backend"