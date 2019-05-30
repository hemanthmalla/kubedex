#! /bin/bash

eval $(minikube docker-env)

docker build -t firedex/experimental-framework ./experimental-framework

docker build -t hemanthmalla/firedex-middleware ./firedex-coordinator-service

docker build -t firedex/setup_rules ./setup-tc-rules
