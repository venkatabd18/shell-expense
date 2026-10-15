#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FOLDER="/var/log/expense"
LOG_FILE=$LOG_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log
mkdir -p /var/log/expense

if [ $USERID -ne 0 ]
then 
    echo -e "$Y Run the script with root access $N" | tee $LOG_FILE
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R failed $N" | tee $LOG_FILE
        exit 1
    else
        echo -e "$2 is $G SUCCESS $N" | tee $LOG_FILE
    fi 
}
echo -e "$Y Script start time : $TIME_STAMP $N" | tee $LOG_FILE