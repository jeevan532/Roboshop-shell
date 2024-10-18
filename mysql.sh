source common1.sh

if [ -z "${mysql_root_pass}" ]; then
  echo "missing mysql root password"
  exit 1
fi

cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo

dnf module disable mysql -y

yum install mysql-community-server -y

systemctl enable mysqld

systemctl start mysqld

mysql_secure_installation --set-root-pass ${mysql_root_pass}
if [ $? -ne 0 ]; then
  echo "mysql_root_pass is already changed"
fi

systemctl restart mysqld


