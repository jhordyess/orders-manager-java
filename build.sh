#!/bin/bash
cp -av ./src/ ./build/
cp -v ./pom.xml ./build/
cd build
docker compose -p orders-man-java -f ./docker-compose.yml up -d
rm -rv ./src ./pom.xml
