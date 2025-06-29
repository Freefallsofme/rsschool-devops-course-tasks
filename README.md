# K3s Kubernetes Cluster on AWS
This project deploys a lightweight Kubernetes cluster using k3s on AWS with a bastion host.

## Steps to Deploy

1. Initialize and apply Terraform:
   ```bash
   terraform init
   terraform apply
SSH to the bastion host:

bash
Копировать
Редактировать
ssh -i ~/.ssh/id_ed25519 ubuntu@<BASTION_PUBLIC_IP>
Copy kubeconfig from the k3s server to the bastion:

bash
Копировать
Редактировать
scp -i ~/.ssh/id_ed25519 ubuntu@<K3S_SERVER_PRIVATE_IP>:/etc/rancher/k3s/k3s.yaml ~/
Edit k3s.yaml and replace 127.0.0.1 with the k3s server’s private IP.

Set kubeconfig environment variable and check nodes:

bash
Копировать
Редактировать
export KUBECONFIG=~/k3s.yaml
kubectl get nodes
Deploy a test pod:

bash
Копировать
Редактировать
kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
kubectl get pods --all-namespaces
