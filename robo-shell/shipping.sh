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

dnf install maven -y &>>$LOGS_FILE
VALIDATE $? "Install maven"

id roboshop  &>>$LOGS_FILE
if [ $? -ne 0 ]; then 
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop  &>>$LOGS_FILE
    VALIDATE $? "Creating user"
else 
     echo "Roboshop user already exit ...... SKIPPING"
fi     

mkdir -p /app 
VALIDATE $? "Creating app dir"

curl -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &>>$LOGS_FILE
VALIDATE $? "Downloading shipping code"

cd /app 
VALIDATE $? "moving to app directory"

rm -rf /app/*
VALIDATE $? "remove the exit code"

unzip /tmp/shipping.zip &>>$LOGS_FILE
VALIDATE $? "Unzip shipping code"


cd /app 
mvn clean package 
VALIDATE $? "package clean"
mv target/shipping-1.0.jar shipping.jar 
VALIDATE $? " moving jar"

cp $script_dir/shipping.service /etc/systemd/system/shipping.service
VALIDATE $? "created systemctl service"

dnf install mysql -y 
VALIDATE $? "install my sql"

mysql -h $mysql_host -uroot -pRoboShop@1 -e 'use cities'

if [ $? -ne 0 ]; then

    mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/schema.sql
    mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/app-user.sql 
    mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/master-data.sql
    VALIDATE $? "install my sql"

else 
   echo "data is already loaded"
fi    


systemctl enable shipping 
systemctl start shipping
VALIDATE $? "enable and tarted shipping" 
