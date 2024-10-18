source common.sh

print_head "installing nginx"
yum install nginx -y &>> $log

print_head "enable nginx"
systemctl enable nginx &>> $log

print_head "starting nginx"
systemctl start nginx

print_head "remove old content"
rm -rf  /usr/share/nginx/html/*

print_head "downloading frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

print_head "unziping frontend file"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

print_head "copying roboshop configuration file"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

print_head "restart nginx"
systemctl restart nginx
