source common.sh

header "installing nginx"
yum install nginx -y &>> $log
status_check()

header "enable nginx"
systemctl enable nginx &>> $log
status_check()

header "starting nginx"
systemctl start nginx
status_check()

header "remove old content"
rm -rf  /usr/share/nginx/html/*
status_check()

header "downloading frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
status_check()

header "unziping frontend file"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
status_check()

header "copying roboshop configuration file"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
status_check()

header "restart nginx"
systemctl restart nginx
status_check()

