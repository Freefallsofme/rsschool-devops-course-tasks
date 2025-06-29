# K3s Kubernetes Cluster on AWS

## Overview

This project deploys a lightweight Kubernetes cluster using k3s on AWS with a bastion host.

## Deployment Steps

1. Initialize and apply Terraform:
   ```bash
   terraform init
   terraform apply
   ```

2. SSH to the bastion host:
   ```bash
   ssh -i ~/.ssh/id_ed25519 ubuntu@13.48.178.154
   ```

3. Copy kubeconfig from the k3s server to the bastion:
   ```bash
   scp -i ~/.ssh/id_ed25519 ubuntu@10.0.3.193:/etc/rancher/k3s/k3s.yaml ~/
   ```
   Edit the downloaded `k3s.yaml` file and replace `127.0.0.1` with `10.0.3.193`.

4. Set kubeconfig environment variable and check cluster nodes:
   ```bash
   export KUBECONFIG=~/k3s.yaml
   kubectl get nodes
   ```

5. Deploy a test pod:
   ```bash
   kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
   kubectl get pods --all-namespaces
   ```
