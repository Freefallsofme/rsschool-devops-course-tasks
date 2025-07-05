## 1. Verify Helm Installation

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install verify-nginx bitnami/nginx


kubectl get pods -l app.kubernetes.io/instance=verify-nginx

Output: 
NAME                           READY   STATUS    RESTARTS   AGE
verify-nginx-bf6464b76-hrhrs   1/1     Running   0          27s


helm uninstall verify-nginx

kubectl get pods -l app.kubernetes.io/instance=verify-nginx
