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



dnf install nginx -y  &>>$LOGS_FILE
systemctl enable nginx &>>$LOGS_FILE
VALIDATE $? "Installing nginx"


systemctl start nginx 
VALIDATE $? "Enabling and started nginx"



rm -rf /usr/share/nginx/html/* 
VALIDATE $? "remove default content"

curl -o /tmp/frontend.zip https://expense-joindevops.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "remove default content"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "Downloaded and unzipped"

rm -rf /etc/nginx/default.d/expense.conf

cp $script_dir/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "copying nginx conf file"

systemctl restart nginx 
VALIDATE $? "restarted nginx"
