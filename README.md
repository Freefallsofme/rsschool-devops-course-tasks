
# Kubernetes Jenkins Deployment

### 1. Create a Namespace for Jenkins
 ```bash
kubectl create namespace devops-tools
 ```
### 2. Create a jenkins-01-serviceAccount.yaml then create the service account using kubectl.
 ```bash
kubectl apply -f jenkins-01-serviceAccount.yaml
 ```
### 3. Create jenkins-02-volume.yaml 
```bash
kubectl create -f jenkins-02-volume.yaml
 ```
### 4. Create a Deployment file named 'jenkins-03-deployment.yaml'
```bash
kubectl apply -f jenkins-03-deployment.yaml
```
### 5. Check the deployment status.
```bash
kubectl get deployments -n devops-tools
```
## Accessing Jenkins Using Kubernetes Service
### 1. Create 'jenkins-04-service.yaml' 
```bash
kubectl apply -f jenkins-04-service.yaml
```
### 2. Access the Jenkins dashboard 
```bash
http://192.168.49.2:32000
```
Check your ip in your case. 
### 3. Get password from logs.
```bash
kubectl logs whateverthenameofyourpodis --namespace=devops-tools
```

### Congrats, you've made it. 


# Jenkins Freestyle Project: Display "Hello world" in Build Logs


### 1. Create a New Freestyle Project

- Open Jenkins in your browser (e.g., http://<jenkins-ip>:<port>)
- Click on **"New Item"** on the left menu
- Enter a name for your project, e.g., `hello-world-job`
- Select **"Freestyle project"**
- Click **OK**

### 2. Add a Build Step

- Scroll down to the **"Build"** section
- Click **"Add build step"**
- Select **"Execute shell"** (for Linux/macOS Jenkins agent) or **"Execute Windows batch command"** (for Windows Jenkins agent)
- In the command box, type:

  ```bash
  echo "Hello world"
```
