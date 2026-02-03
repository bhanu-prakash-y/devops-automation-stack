#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
LOGS_FILE="/var/log/shell-script/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


if [ $USERID -ne 0 ]; then
    echo -e "$R please run this script root acccess $N" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
         echo -e "$2 ... $R FAILURE $N" | tee -a $LOGS_FILE
         exit 1
    else    
      echo -e "$2 ... $G SUCCESS $N"    | tee -a $LOGS_FILE
    fi 
}

for Package in  $@ 
do
   dnf list  installed  $Packages &>>$LOGS_FILE
  if [ $? -ne 0 ]; then
     echo "$Package not installed, install now"
     dnf install $Package -y &>>$LOGS_FILE
     VALIDATE $? "$Package installation"
 else
      echo -e "$Package already installed ... $Y SKIPPING $N" 
   fi

done