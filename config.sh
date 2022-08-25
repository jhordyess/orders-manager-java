#!/bin/bash
# TODO "docBase" string auto
## project_name=${PWD##*/}
full_path=$(realpath .)
mvn clean package
sudo printf "<Context docBase=\"${full_path}/target/orders-manager.war\"/>" | sudo tee -a ${CATALINA_HOME}/conf/Catalina/localhost/ROOT.xml
sudo catalina.sh start