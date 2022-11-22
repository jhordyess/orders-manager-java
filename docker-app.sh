#!/bin/bash
IMAGE_NAME="orders-man-java"
docker compose -p ${IMAGE_NAME} -f ./docker-compose.yml up -d
