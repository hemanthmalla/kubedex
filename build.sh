#! /bin/bash

mvn package -DskipTests -f static/publisher/

mvn package -DskipTests -f static/mqtt-sn-broker/

mvn package -DskipTests -f static/mqtt-broker/

#mvn package -DskipTests -f static/subscriber/

rm -rf ./build
mkdir -p ./build/static/config/
mkdir ./build/static/subscriber_configurations/

cp -r static/*/target/*dependencies*.jar ./build/static/

cp static/publisher/publisher.json ./build/static/config/
cp static/subscriber/subscriber.json ./build/static/config/
cp static/mqtt-broker/moquette.configuration ./build/static/config/
cp static/mqtt-sn-broker/gateway.properties ./build/static/config/
cp static/mqtt-sn-broker/predefinedTopics.properties ./build/static/config/

eval $(minikube docker-env)
docker build -t hemanthmalla/firedex ./




