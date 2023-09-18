#!/bin/bash

function build() {
  # Prepare the project
  mvn clean install

  # Initialize tomcat
  initTomcat

  echo "Deployed!, visit http://localhost:8080 and refresh the page"
}

# Check if tomcat is not running and start it
function initTomcat() {
  TOMCAT_PID=$(ps -ef | awk '/[t]omcat/{print $2}')

  if [ -z "$TOMCAT_PID" ]; then
    echo "Tomcat is not running, starting it..."
    catalina.sh start
  else
    echo "Tomcat is running"
  fi
}

echo "Building..."
build

while true; do
  read -n 1 -srp "Press 'b' to build again or 'q' to quit: " choice
  case "$choice" in
  b | B)
    echo "Building..."
    build
    ;;
  q | Q)
    echo "Exiting..."
    exit 0
    ;;
  *)
    echo "Invalid option"
    ;;
  esac
done
