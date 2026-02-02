#!bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo "please run this script root acccess"
    exit 1
fi

VAILDATE(){
if [ $1 -ne 0 ]; then
    echo "$2........FAILURE"
    exit 1
else    
      echo "$2........SUCCESS"
fi 

}

dnf install nginx -y
VAILDATE $? "Installing Nginx"

dnf install mysql -y
VAILDATE $? "Installing Mysql"

dnf install nodejs -y
VAILDATE $? "Installing nodejs"
