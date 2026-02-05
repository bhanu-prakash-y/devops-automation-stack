#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
script_dir=$PWD
mysql_host=$mysql.bhanudevops.online

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


cp $script_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "added rabbitmq"


dnf install rabbitmq-server -y
VALIDATE $? "install server"

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
VALIDATE $? "enabled and started server"


rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "created user and given permission"
