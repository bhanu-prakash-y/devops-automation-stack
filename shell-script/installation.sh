#!bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo "please run this script root acccess"
    exit 1
fi

echo "Installing Nginx"
dnf install nginx -y