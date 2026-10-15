#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)

if [ $USERID -ne 0 ]
then 
    echo -e "$Y Run the script with root access $N"
    exit 1
fi

echo -e "$Y Script start time : $TIME_STAMP $N"

dnf list installed mysql
if [ $? -ne 0 ]
then
    echo "Mysql server not installed, going to install"
else
    echo Mysql server already installed.. nothing to do
    exit 1
fi 
