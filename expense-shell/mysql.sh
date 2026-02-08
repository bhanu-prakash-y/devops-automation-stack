#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-expense"
LOGS_FILE="$LOGS_FOLDER/$0.log"
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


dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "Installing  mysql"

systemctl enable mysqld &>>$LOGS_FILE
systemctl start mysqld  
VALIDATE $? "start my sql"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Restarting set up root"

mysql -h $mysqldb_host -u root -pRoboShop@1