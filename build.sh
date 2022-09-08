#!/bin/bash
cp -av ./src/ ./build/
cp ./pom.xml ./build/
cd build
docker compose -p orders-man-java -f ./docker-compose.yml up -d
rm -rf ./src ./pom.xml
