source common.sh

print_head "installing nginx"
yum install nginx -y &>> $log
status_check()

print_head "enable nginx"
systemctl enable nginx &>> $log
status_check()

print_head "starting nginx"
systemctl start nginx
status_check()

print_head "remove old content"
rm -rf  /usr/share/nginx/html/*
status_check()

print_head "downloading frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
status_check()

print_head "unziping frontend file"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
status_check()

print_head "copying roboshop configuration file"
cd roboshop-shell
status_check()

cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
status_check()

print_head "restart nginx"
systemctl restart nginx
status_check()

