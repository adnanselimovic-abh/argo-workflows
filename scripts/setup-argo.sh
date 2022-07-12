#!/bin/bash

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
alias k=kubectl

k create ns argo
k create ns argo-events

helm upgrade --install atlantbh charts/argo-workflows --namespace argo --values charts/argo-values.yaml
helm upgrade --install atlantbh charts/argo-events --namespace argo-events --values charts/argo-values.yaml

k apply -f scripts/resources/raw/yaml/setup/ingresses.yaml
k apply -f scripts/resources/raw/yaml/argo-workflows/service-account-workflow.yaml
k apply -f scripts/resources/raw/yaml/argo-events/service-account-events.yaml
k apply -f scripts/resources/raw/yaml/argo-events/webhook-source.yaml
k apply -f scripts/resources/raw/yaml/argo-events/eventbus-default.yaml
k apply -f scripts/resources/raw/yaml/argo-events/webhook-sensor.yaml

