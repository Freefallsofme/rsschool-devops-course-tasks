### Task 7 – Prometheus Deployment on K8s

## Monitoring Setup for Kubernetes Cluster.

This repository contains the configuration for setting up a monitoring stack in a Kubernetes cluster using Prometheus, Grafana, and smtp4dev. The setup includes a custom dashboard (Task dashboard) and alerting rules for CPU and RAM usage, with notifications sent via email.
Overview

The monitoring stack is deployed in the monitoring namespace and consists of:

1. Prometheus: Collects and stores metrics from the Kubernetes cluster (e.g., CPU, memory, disk usage).
2. Grafana: Visualizes metrics through the Task dashboard and manages alerts.
3. smtp4dev: Receives email notifications for alerts triggered by Grafana.

The custom dashboard (Task dashboard) is located in the MonitoringRules folder in Grafana and displays CPU, memory, and disk metrics. Two alerting rules are configured:

1. High CPU Usage: Triggers when CPU usage exceeds 95% for 1 minute.
2. Low RAM Capacity: Triggers when available RAM falls below 1% for 1 minute.

Current metrics (CPU: 6.5%, RAM: 27.004%) ensure alerts are in Normal state (though currently in Firing, pending further debugging).
## Repository Structure

monitoring/
├── prometheusval.yaml            # Configuration for Prometheus Helm chart

├── grafanaval.yaml               # Configuration for Grafana Helm chart

├── smtp4dev.yaml                 # Deployment and Service for smtp4dev

├── grafana-provisioning/

│   ├── alerting/

│   │   └── rules.yaml            # Alerting rules for CPU and RAM

│   ├── notifications/

│   │   ├── contactpoints.yaml    # Email notification settings

│   │   └── policies.yaml         # Notification routing policies

│   ├── dashboards/

│   │   └── custom-dashboard.json # Custom Grafana dashboard

├── deploy_monitoring.sh          # Script to deploy the monitoring stack

└── README.md                     # This file

## Prerequisites

Kubernetes cluster (e.g., Minikube)
Helm 3 installed
kubectl configured to interact with the cluster
Git for cloning the repository

## Installation

Clone the repository:
`git clone <repository-url>
cd monitoring`


Run the deployment script:
`chmod +x deploy_monitoring.sh
./deploy_monitoring.sh`

## The script:

Creates the monitoring namespace.
Adds Helm repositories for Prometheus and Grafana.
Deploys Prometheus using prometheusval.yaml.
Deploys smtp4dev using smtp4dev.yaml.
Creates a secret for Grafana admin password (grafana-env).
Creates ConfigMaps for alerting (grafana-provisioning) and dashboard (grafana-dashboards).
Deploys Grafana using grafanaval.yaml.



## Verification

Check running pods:
`kubectl get pods -n monitoring`

Ensure all pods (Prometheus, Grafana, smtp4dev, etc.) are in Running state.

Access Prometheus:
`kubectl port-forward svc/prometheus-server 9090:80 -n monitoring`

Open http://localhost:9090 and verify metrics (node_cpu_seconds_total, node_memory_MemAvailable_bytes, node_filesystem_size_bytes).

Access Grafana:
`kubectl port-forward svc/grafana 3000:80 -n monitoring`

Open http://localhost:3000, log in with:

Username: admin

Password: `Run kubectl get secret grafana-env -n monitoring -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 -d (default: mysecretpassword)`

Verify the Prometheus datasource in Configuration > Data Sources.

Check the Task dashboard in Dashboards > Browse > MonitoringRules.

Verify alerts (High CPU Usage, Low RAM Capacity) in Alerting > Alert Rules. They should be in Normal state.



Access smtp4dev:
`kubectl port-forward svc/smtp4dev 8080:80 -n monitoring`

Open http://localhost:8080 to check for alert notification emails (none expected if alerts are Normal).



