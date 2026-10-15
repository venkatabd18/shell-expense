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

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 is failed"
        exit 1
    else
        echo "$2 is SUCCESS"
    fi 
}
echo -e "$Y Script start time : $TIME_STAMP $N"

dnf list installed mysql
if [ $? -ne 0 ]
then
    echo "Mysql server not installed, going to install"
    dnf install mysql-server -y
    VALIDATE $? "Mysql installation"
else
    echo Mysql server already installed.. nothing to do
fi 

systemctl enable mysqld
VALIDATE $? "mysqld enabled"

systemctl start mysqld
VALIDATE $? "Mysqld started"

mysql -h mysql.venra.online -u root -pExpenseApp@1 -e 'show databases';
if [ $? -ne 0 ]
then
    echo "root password not set. setting up"
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting up root password"
fi
