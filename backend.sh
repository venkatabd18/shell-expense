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
    echo -e "$Y Run the script with root access $N" | tee -a $LOG_FILE
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R failed $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is $G SUCCESS $N" | tee -a $LOG_FILE
    fi 
}
echo -e "$Y Script start time : $TIME_STAMP $N" | tee -a $LOG_FILE

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "disabled nodejs"

dnf module enable nodejs:24 -y &>>$LOG_FILE
VALIDATE $? "enabled node js"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "installed nodejs"

node -v | tee -a $LOG_FILE
VALIDATE $? "Verify nodejs"

mkdir -p /app
VALIDATE $? "app dir creation"

id expense
if [ $? -ne 0 ]
then
    echo "expense user not availble. creating" &>>$LOG_FILE
    useradd expense
    VALIDATE $? "expence user creation"
fi

curl -o /tmp/backend.tar.gz https://raw.githubusercontent.com/daws-92s/expense-documentation/refs/heads/main/artifacts/expense-backend-v5.tar.gz &>>$LOG_FILE
VALIDATE $? "download the backend code"

cd /app
tar -xzf /tmp/backend.tar.gz 
VALIDATE $? "extracting backend code"

cd /app
npm install
VALIDATE $? "npm instalation"

cp /home/ec2-user/shell-expense/backend.service /etc/systemd/system/backend.service
VALIDATE $? "copy service"

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "mysql client instalation"

mysql -h <MYSQL-SERVER-IPADDRESS> -u root -pExpenseApp@1 < /app/schema/backend.sql
VALIDATE $? "loading schema"

systemctl daemon-reload
VALIDATE $? "daemon reload"

systemctl enable backend
VALIDATE $? "enabled backend"

systemctl start backend
VALIDATE $?  "start backend"


