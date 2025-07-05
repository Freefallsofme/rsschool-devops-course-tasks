# Jenkins Installation and Configuration

## 1. Verifying Helm
 ```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
 ```
 ```bash
helm install verify-nginx bitnami/nginx
 ```
```bash
kubectl get pods -l app.kubernetes.io/instance=verify-nginx
 ```
Output: 
 ```bash
NAME                           READY   STATUS    RESTARTS   AGE
verify-nginx-bf6464b76-hrhrs   1/1     Running   0          27s
 ```
 ```bash
helm uninstall verify-nginx
 ```
 ```bash
kubectl get pods -l app.kubernetes.io/instance=verify-nginx
 ```

## 2. Cluster Requirements
