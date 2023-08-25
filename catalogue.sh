#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE

VALIDATE $? "Setting up NPM Source"

yum install nodejs -y &>> $LOGFILE

useradd roboshop &>> $LOGFILE

mkdir /app &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

cd /app &>> $LOGFILE

unzip /tmp/catalogue.zip &>> $LOGFILE

cd /app &>> $LOGFILE

npm install &>> $LOGFILE

cp home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

systemctl daemon-reload &>> $LOGFILE

systemctl enable catalogue &>> $LOGFILE

systemctl start catalogue &>> $LOGFILE

cp home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

yum install mongodb-org-shell -y &>> $LOGFILE

mongo --host mongodb.saikirandevops.cloud </app/schema/catalogue.js&>> $LOGFILE