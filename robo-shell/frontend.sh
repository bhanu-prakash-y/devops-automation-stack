#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
script_dir=$PWD

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


dnf module disable nginx -y &>>$LOGS_FILE
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
dnf install nginx -y
VALIDATE $? "Installing nginx"

systemctl enable nginx   &>>$LOGS_FILE
systemctl start nginx    &>>$LOGS_FILE
VALIDATE $? "started  nginx"


rm -rf /usr/share/nginx/html/* 
VALIDATE $? "remove default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "remove default content"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "Downloaded and unzipped"

rm -rf /etc/nginx/nginx.conf

cp $script_dir/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "copying nginxconf file"

systemctl restart nginx 
VALIDATE $? "restarted nginx"
