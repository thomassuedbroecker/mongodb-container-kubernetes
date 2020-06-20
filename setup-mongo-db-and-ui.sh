#!/bin/bash
CLUSTER_NAME=cloud-native
NAMESPACE=mongo-db
SERVICE_NAME_DATABASE=mongo-database
SERVICE_NAME_EXPRESS=mongo-express

# You need to connect to the your free Kubernetes Cluster on IBM Cloud first

# Create and set namespace
kubectl create ns $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

# Setup Docker image for the mongo db
kubectl apply -f mongo-docker.yaml

# Get the needed information to access the database
workernodeip=$(ibmcloud ks workers --cluster $CLUSTER_NAME | awk '/Ready/ {print $2;exit;}')
echo "workernodeip:$workernodeip"
nodeport=$(kubectl get svc $SERVICE_NAME_DATABASE --output 'jsonpath={.spec.ports[*].nodePort}')
echo "nodeport:$nodeport"

kubectl get pods -n $NAMESPACE
echo "Link to the mongo db: http://$workernodeip:$nodeport/"

# Setup Docker image for the mongo db UI
kubectl apply -f mongo-express-docker.yaml

# Get the needed information to access database ui
nodeport=$(kubectl get svc $SERVICE_NAME_EXPRESS --output 'jsonpath={.spec.ports[*].nodePort}')
echo "nodeport:$nodeport"
echo "Link to the mongo db WebUI: http://$workernodeip:$nodeport/"
