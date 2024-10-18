source common1.sh

print_head "copy conf file"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo
status_check

print_head "install mongod"
yum install mongodb-org -y
status_check

print_head "enable mongod"
systemctl enable mongod
status_check

print_head "start mongod"
systemctl start mongod
status status_check

print_head "change configuration of listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}
status_check

systemctl restart mongod

