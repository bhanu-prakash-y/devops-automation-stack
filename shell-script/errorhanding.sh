#!/bin/bash

set -e
trap 'echo "There is an error in $LINEND, Command: $BASH_COMMAND"' ERR 

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
LOGS_FILE="/var/log/shell-script/$0.log"

if [ $USERID -ne 0 ]; then
    echo "Please run this script with root user  acccess" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

for Package in $@

do
    dnf list  installed  $Package &>>$LOGS_FILE

  if [ $? -ne 0 ]; then

       echo "$Package not installed, installing now"

       dnf install $Package -y &>>$LOGS_FILE

   else
    
        echo "$Package already installed ... SKIPPING" 
   fi
   
done