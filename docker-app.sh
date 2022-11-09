#!/bin/bash
cp -av ./src/ ./build/docker/
cp -v ./pom.xml ./build/docker/
cd build/docker
docker compose -p orders-man-java -f ./docker-compose.yml up -d
rm -rv ./src ./pom.xml
