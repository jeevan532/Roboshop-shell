pwd=${pwd}

set -e
log=/tmp/roboshop.log

echo -e "\e[35m install nginx \e[0m"
yum install nginx -y &>> $log

echo -e "\e[35m enable nginx \e[0m"
systemctl enable nginx &>> $log

echo -e "\e[35m start nginx \e[0m"
systemctl start nginx

echo -e "\e[35m remove old content \e[0m"
rm -rf  /usr/share/nginx/html/*

echo -e "\e[35m download frontend content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 

echo -e "\e[35m cd to html \e[0m"
cd /usr/share/nginx/html

echo -e "\e[35m unzip frontend file \e[0m"
unzip /tmp/frontend.zip

echo -e "\e[35m copying roboshop conf file \e[0m"
cp ${pwd}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[35m restart nginx \e[0m"
systemctl restart nginx


