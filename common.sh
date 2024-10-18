log=/tmp/roboshop.log
script_location=$(pwd)

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;31m success \e[0m"
  else
    echo "failure, refer log at -${log}"
  fi
}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}

app_prereq() {
  print_head "add app user"
  id roboshop &>>${log}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${log}
  fi
  status_check

  mkdir -p /app

  print_head "download app content"
  curl -L -o curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  status_check

  print_head "removing old app content"
  rm -rf /app/*

  print_head "unziping app content"
  cd /app
  unzip /tmp/${component}.zip
}

systemd_setup() {
  print_head "cp ${component} file to systemd"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service
  status_check

  print_head "reloading the ${component} service"
  systemctl daemon-reload
  status_check

  print_head "enabling ${component} service "
  systemctl enable ${component}
  status_check

  print_head "starting ${component} service "
  systemctl start ${component}
  status_check
}

load_schema() {
  if [ ${shema_load} == true ]; then
    if [ ${schema_type} == mongodb ]; then
       print_head "Configuring Mongo Repo "
       cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo
       status_check

       print_head "Install Mongo Client"
       yum install mongodb-org-shell -y
       status_check

       print_head "Load Schema"
       mongo --host mongodb-dev.devopsb70.online </app/schema/${component}.js
       status_check
    fi
    if [ $shcema_type == mysql ]; then
       print_head "Install MySQL Client"
       yum install mysql -y &>>${log}
       status_check

       print_head "Load Schema"
       mysql -h mysql-dev.devops007.online -uroot -p${root_mysql_password} < /app/schema/shipping.sql  &>>${log}
       status_check
    fi
  fi
}

nodejs() {
  app_prereq

  print_head "downloading nodejs "
  curl –sL https://rpm.nodesource.com/setup_10.x | bash
  status_check

  print_head "installing nodejs"
  yum install nodejs -y
  status_check

  print_head "downloading dependencies"
  npm install
  status_check

  load_schema

  systemd_setup
}

maven() {
  app_prereq

  systemd_setup

  print_head "download maven"
  yum install maven -y
  status_check

  print_head "download dependencies"
  mvn clean package
  status_check

  print_head "move jar file"
  mv target/${component}-1.0.jar ${component}.jar
  status_check

  load_schema

}

python() {
  app_prereq

  print_head "install python gcc"
  yum yum install python36 gcc python3-devel -y &>>${log}
  status_check

  print_head "download depencecies"
  pip3.6 install -r requirements.txt
  status_check

  print_head "Update Passwords in Service File"
  sed -i -e "s/roboshop_rabbitmq_password/${roboshop_rabbitmq_password}/" ${script_location}/files/${component}.service  &>>${LOG}
  status_check

  systemd_setup
}


