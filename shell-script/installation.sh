#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo "please run this script root acccess"
    exit 1
fi

echo "Installing Nginx"
dnf install nginx -y

if [ $? -ne 0]; then
    echo "Installing Ngnix........FAILURE"
    exit 1

else    
 echo "Installing Ngnix........SUCCESS"
fi 


dnf install mysql -y

if [ $? -ne 0]; then
    echo "Installing MYSQL........FAILURE"
    exit 1

else    
 echo "Installing MYSQL........SUCCESS"
fi 


dnf install nodejs -y

if [ $? -ne 0]; then
    echo "Installing nodejs........FAILURE"
    exit 1

else    
 echo "Installing nodejs........SUCCESS"
fi 
