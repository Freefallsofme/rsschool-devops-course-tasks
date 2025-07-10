# Task 5 – Flask App Deployment via Helm

## Description

This is a simple Flask application that returns `Hello, World!` and is deployed to a Kubernetes cluster using a custom Helm chart.

---

## Project Structure

```
rsschool-devops-course-tasks/
├── app/
│   └── flask-app/
│       ├── main.py
│       ├── requirements.txt
│       ├── Dockerfile
│       └── helm/
│           └── flask-app/  ← Helm Chart
├── README.md
```

---

## Deployment Instructions

### 1. Build and Push Docker Image

```bash
docker build -t <dockerhub_username>/flask-app:latest app/flask-app
docker push <dockerhub_username>/flask-app:latest
```

### 2. Deploy with Helm

```bash
helm upgrade --install flask-app helm/flask-app \
  --namespace default --create-namespace \
  --values helm/flask-app/values.yaml
```

### 3. Get Application URL

```bash
export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services flask-app)
export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
echo "http://$NODE_IP:$NODE_PORT"
```

### 4. Check in Browser

Navigate to the printed URL. You should see:

```
Hello, World!
```

## Helm Release Status

```bash
helm list -n default
```

---
