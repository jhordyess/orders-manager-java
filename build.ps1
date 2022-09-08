cp -r ./src/ ./build/
cp ./pom.xml ./build/
docker compose -p orders-man-java -f ./build/docker-compose.yml up -d
rm -r ./build/src
rm ./build/pom.xml
