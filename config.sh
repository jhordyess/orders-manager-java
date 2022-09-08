#!/bin/bash
full_path=$(realpath .)
mvn clean package
sudo su jhordyess -c "catalina.sh stop"
sudo rm -rf ${CATALINA_HOME}/webapps/*
sudo cp -r ${full_path}/target/orders-manager ${CATALINA_HOME}/webapps/ROOT
sudo su jhordyess -c "catalina.sh run"
