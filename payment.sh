source common1.sh

component=payment
schema_load=false

if [ -z "$roboshop_rabbitmq_password" ]; then
  echo "roboshop_rabbitmq_password is missing"
  exit 1
fi

PYTHON

