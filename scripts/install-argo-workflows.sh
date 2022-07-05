#!/bin/bash

kubectl create ns argo
helm upgrade --install atlantbh charts/argo-workflows --namespace argo --values charts/argo-values.yaml

kubectl apply -f scripts/resources/raw/yaml/setup/ingresses.yaml