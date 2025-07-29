#!/bin/bash

# Checking or creating namespace
kubectl get namespace monitoring > /dev/null 2>&1 || kubectl create namespace monitoring

# Adding Helm-repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install or updating Prometheus
helm upgrade --install prometheus prometheus-community/prometheus -n monitoring -f prometheusval.yaml

# Deploying smtp4dev
kubectl apply -f smtp4dev.yaml

# Creating secret for Grafana's admin
kubectl get secret grafana-env -n monitoring > /dev/null 2>&1 || kubectl create secret generic grafana-env --from-literal=GF_SECURITY_ADMIN_PASSWORD=mysecretpassword -n monitoring

# Creating ConfigMap for provisioning Grafana
kubectl create configmap grafana-provisioning \
  --from-file=rules.yaml=grafana-provisioning/alerting/rules.yaml \
  --from-file=contactpoints.yaml=grafana-provisioning/notifications/contactpoints.yaml \
  --from-file=policies.yaml=grafana-provisioning/notifications/policies.yaml \
  -n monitoring

# Creating ConfigMap for dashboard
kubectl create configmap grafana-dashboards \
  --from-file=custom-dashboard.json=grafana-provisioning/dashboards/custom-dashboard.json \
  -n monitoring

# Install or updating Grafana
helm upgrade --install grafana grafana/grafana -n monitoring -f grafanaval.yaml
