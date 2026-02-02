#!bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo "please run this script root acccess"

fi

echo "Installing Nginx"
dnf install nginx -y