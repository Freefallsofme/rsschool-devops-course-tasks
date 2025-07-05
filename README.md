
# Kubernetes Jenkins Deployment
1. Create a Namespace for Jenkins
 ```bash
kubectl create namespace devops-tools
 ```
 2. Create a jenkins-01-serviceAccount.yaml then create the service account using kubectl.
 ```bash
kubectl apply -f jenkins-01-serviceAccount.yaml
 ```
 3. Create jenkins-02-volume.yaml 
```bash
kubectl create -f jenkins-02-volume.yaml
 ```
 4. Create a Deployment file named 'jenkins-03-deployment.yaml'
```bash
kubectl apply -f jenkins-03-deployment.yaml
```
 5. Check the deployment status.
```bash
kubectl get deployments -n devops-tools
```
## Accessing Jenkins Using Kubernetes Service
 1. Create 'jenkins-04-service.yaml' 
```bash
kubectl apply -f jenkins-04-service.yaml
```
2. Access the Jenkins dashboard 
```bash
http://192.168.49.2:32000
```
Check your ip in your case. 
3. Get password from logs.
```bash
kubectl logs whateverthenameofyourpodis --namespace=devops-tools
```

Congrats, you've made it. 
