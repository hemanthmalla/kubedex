#! /bin/bash

kubectl create ns firedex

kubectl create -f k8s/broker.yaml
kubectl create -f k8s/gateway.yaml
kubectl create -f k8s/middleware.yaml
kubectl create -f k8s/subscriber.yaml
kubectl create -f k8s/publisher.yaml
