#! /bin/bash

mvn package -DskipTests -f static/publisher/

mvn package -DskipTests -f static/subscriber/

mvn package -DskipTests -f static/mqtt-sn-broker/

mvn package -DskipTests -f static/mqtt-broker/

mkdir -p ./build/static/config/

cp -r static/*/target/*.jar ./build/static/

cp static/publisher/publisher.json ./build/static/config/
cp static/subscriber/subscriber.json ./build/static/config/
cp static/mqtt-broker/moquette.configuration ./build/static/config/
cp static/mqtt-sn-broker/gateway.properties ./build/static/config/

docker build -t hemanthmalla/firedex ./




