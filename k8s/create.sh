#! /bin/bash

kubectl create ns firedex

kubectl create -f broker.yaml
kubectl create -f gateway.yaml
kubectl create -f middleware.yaml
kubectl create -f subscriber.yaml
kubectl create -f publisher.yaml
