#!/bin/bash

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

while [[ $(kubectl get crd | grep ingressroutes.traefik.containo.us | wc -l) == 0 ]];
do
  sleep 5
done;

kubectl create ns argo
kubectl create ns argo-events
kubectl create ns go-api

helm upgrade --install atlantbh charts/argo-workflows --namespace argo --values charts/argo-workflows/argo-values.yaml
helm upgrade --install atlantbh charts/argo-events --namespace argo-events --values charts/argo-events/argo-values.yaml

kubectl apply -f scripts/resources/raw/yaml/setup/ingresses.yaml
kubectl apply -f scripts/resources/raw/yaml/argo-workflows/service-account-workflow-executor.yaml
kubectl apply -f scripts/resources/raw/yaml/argo-events/service-account-events.yaml
kubectl apply -f scripts/resources/raw/yaml/argo-events/webhook-source.yaml
kubectl apply -f scripts/resources/raw/yaml/argo-events/eventbus-default.yaml
kubectl apply -f scripts/resources/raw/yaml/argo-events/webhook-sensor.yaml

kubectl apply -f scripts/resources/raw/yaml/argo-workflows/role-go-api.yaml
kubectl apply -f scripts/resources/raw/yaml/argo-workflows/workflow-cicd-template.yaml
