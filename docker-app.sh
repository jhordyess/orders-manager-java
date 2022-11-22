#!/bin/bash
APP_NAME="orders-man-java"
docker compose -p ${APP_NAME} -f ./docker-compose.yml up -d
