cp -r ./src/ ./build/docker/
cp ./pom.xml ./build/docker/
docker compose -p orders-man-java -f ./build/docker/docker-compose.yml up -d
rm -r ./build/docker/src
rm ./build/docker/pom.xml
