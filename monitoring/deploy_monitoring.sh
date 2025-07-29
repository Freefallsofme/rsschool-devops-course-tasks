#!/bin/bash

# Проверяем и создаем namespace, если он не существует
kubectl get namespace monitoring > /dev/null 2>&1 || kubectl create namespace monitoring

# Добавляем Helm-репозитории
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Устанавливаем или обновляем Prometheus
helm upgrade --install prometheus prometheus-community/prometheus -n monitoring -f prometheusval.yaml

# Разворачиваем smtp4dev
kubectl apply -f smtp4dev.yaml

# Создаем секрет для админа Grafana, если он не существует
kubectl get secret grafana-env -n monitoring > /dev/null 2>&1 || kubectl create secret generic grafana-env --from-literal=GF_SECURITY_ADMIN_PASSWORD=mysecretpassword -n monitoring

# Создаем ConfigMap для provisioning Grafana
kubectl create configmap grafana-provisioning \
  --from-file=rules.yaml=grafana-provisioning/alerting/rules.yaml \
  --from-file=contactpoints.yaml=grafana-provisioning/notifications/contactpoints.yaml \
  --from-file=policies.yaml=grafana-provisioning/notifications/policies.yaml \
  -n monitoring

# Устанавливаем или обновляем Grafana
helm upgrade --install grafana grafana/grafana -n monitoring -f grafanaval.yaml
