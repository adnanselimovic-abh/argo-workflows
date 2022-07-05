#!/bin/bash

kubectl create ns argo
helm install atlantbh charts/argo-workflows --values charts/argo-values.yaml

kubectl apply -f resources/raw/yaml/ingresses.yaml