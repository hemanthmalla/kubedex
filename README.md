# kubdex

## Components needed

* Docker
* Minikube 
* Maven
* Virtualbox (Needed for Minikube)

## Setup

Once virtualbox is installed, it is recommended to run minikube with enough resources. We install Kubernetes 1.14 and verify if the pods are up and running.

```
minikube start --memory=8192 --cpus=4 --kubernetes-version=v1.14.0 
kubectl get pods --all-namespaces
```

Firedex components will be running in the VM, so we need to transport our docker images into the VM. Dealing with local images is faster for development purposes. So, we connect to the VM's docker deamon from the host machine and build images directly into the VM. This can be done with 

```
eval $(minikube docker-env)
```

Note : In order to make this work, we set image pull policy in Kubernetes manifests to never. This will force the usage of existing images.

UDP Client package is currently not available on public maven repository. So, clone the project and add it to the local maven repository

```
mkdir libs && cd libs
git clone https://github.com/hemanthmalla/eclipse-paho-mqtt-sn-udp-client.git
mvn install
cd ..
```
Maven package broker, gateway, publisher and subscriber components. Build a docker image from the artifacts generated.

```
bash build.sh
```

Build docker image for the middleware.

```
docker build -t <image_name> ./static/firedex-coordinator-service
```

Additionally we can verify that the images are built into the VM. We also need to create log directory in minikube, which would be mounted into containers.

```
minikube ssh
docker images
mkdir -p /home/docker/data/publisher
mkdir -p /home/docker/data/subscriber
exit
```

Now, we're ready to deploy to kubernetes.
```
bash ./k8s/create.sh
```

Verify if all the components are up and running.

```
kubectl get pods -n firedex
```
The same can be verified on the Kubernetes dashboard. 

```
minikube dashboard
```

Experiment results can obtained from /home/docker/data in the minikube VM.


Delete firedex installtion 

```
bash ./k8s/del.sh && minikube stop
```