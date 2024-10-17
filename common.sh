log=/tmp/roboshop.log
script_location=${pwd}

status_check() {
  if [$? -eq 0]; then
    echo -e "\e[31m success\e[0m"
  else
    echo "failure, refer log at -$(log)"
  fi
}
header() {
  echo -e "\e[1m $1 \e[0m"
}