#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
LOGS_FILE="/var/log/shell-script/$0.log"

if [ $USERID -ne 0 ]; then
    echo "please run this script root acccess" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
         echo "$2 ... FAILURE" | tee -a $LOGS_FILE
         exit 1
    else    
      echo "$2 ... SUCCESS"    | tee -a $LOGS_FILE
    fi 
}

for Package in  $@    #sudo loop.sh nodejs mysql
do
   dnf list  installed  $Packages &>>$LOGS_FILE
  if [ $? -ne 0 ]; then
     echo "$Package not installed, install now"
     dnf install $Package -y &>>$LOGS_FILE
     VALIDATE $? "$Package installation"
 else
      echo "$Package already installed ..... SKIPPING" 
   fi
done