# End-to-End Secure Deployment of an App on EKS with Port and Akeyless

This workshop guides participants through deploying applications on Amazon EKS using Port for platform engineering and Akeyless for secrets management.

## What You'll Build
- A secure infrastructure deployment pipeline using Port and Akeyless
- An EKS cluster using Terraform as the Infrastructure as Code tool
- Scaffolding of a Node.js application with a repo and an AWS ECR repository
- Deploying the application to the EKS cluster from Port using GitHub Actions secrets from Akeyless

## Key Learning Objectives
1. **Environment Setup**: Configure a development environment using GitHub Codespaces and minikube
2. **Secrets Management**: Implement Akeyless for secure secrets handling:
   - OIDC authentication
   - API key management
   - Gateway setup and configuration
   - Dynamic AWS credentials
3. **Platform Engineering**: Set up Port for:
   - Self-service infrastructure provisioning
   - Application deployment automation
   - Infrastructure visibility
4. **Infrastructure as Code**: Deploy and manage EKS clusters using Terraform
5. **Application Deployment**: Deploy applications using automated workflows

## Workshop Labs

1. [Lab 1: Environment Setup](Lab01/guide.md)
   - Fork repository and setup GitHub Codespace
   - Configure AWS access
   - Initialize minikube cluster

2. [Lab 2: Akeyless Setup](Lab02/guide.md)
   - Configure OIDC authentication
   - Create API keys and access roles
   - Set up Akeyless Gateway
   - Create dynamic AWS secrets

3. [Lab 3: GitHub Actions Pipeline](Lab03/guide.md)
   - Configure GitHub Actions
   - Set up repository variables
   - Enable workflow automation

4. [Lab 4: Port Setup](Lab04/guide.md)
   - Install Port's GitHub app
   - Create blueprints for regions and clusters
   - Configure self-service actions
   - Set up Port credentials in Akeyless

5. [Lab 5: EKS Cluster Deployment](Lab05/guide.md)
   - Deploy EKS cluster through Port
   - Configure cluster access
   - Verify deployment

6. [Lab 6: Application Deployment](Lab06/guide.md)
   - Scaffold a Node.js application via a Port Self-Service Action
   - Deploy the application to the EKS cluster from Port using GitHub Actions with secrets from Akeyless
   - Verify application deployment

7. [Lab 7: Destroy the EKS Cluster](Lab07/guide.md)
   - Create self-service action in Port to destroy the EKS cluster
   - Run the destroy cluster action
   - Verify cluster deletion

## Prerequisites
- GitHub account
- Basic understanding of:
  - Kubernetes and EKS
  - Infrastructure as Code, preferably Terraform
  - CI/CD concepts
  - Container basics

## Getting Started
Begin with [Lab 1: Environment Setup](Lab01/guide.md) to start your journey through the workshop.

## If Your Codespace Times Out
If your codespace times out or needs to be restarted, follow these steps:

### 1. Run the keep alive command

```bash
while true; do date; sleep 60; done
```

### 2. Run minikube
```bash
minikube start --cpus 3 --memory 8g
```

### 3. Get all pods
Once the minikube cluster is ready, check the status of all pods:
```bash
watch kubectl get pods -A
```
wait till they are all running except for the Akeyless Gateway pods (will be in 0/1 Running state) and the Flask application pod (will be in 0/ CrashLoopBackOff state).

### 4. Delete the Akeyless Gateway Replicaset which will restart it

```bash
kubectl delete replicaset gw-akeyless-api-gateway-<random-string> -n akeyless
```

Check the status of all pods again:
```bash
watch kubectl get pods -A
```

wait till the Akeyless Gateway pods are in a 1/1 Running state.

### 5. Port forward the services

#### 5.1 ArgoCD UI
```bash
kubectl port-forward -n argocd service/argocd-server 3000:443
```
Remember to set the port protocol to HTTPS in the Ports tab.

#### 5.2 Akeyless Gateway
```bash
kubectl port-forward svc/gw-akeyless-api-gateway 8000:8000 -n akeyless
```
Remember to set the port visibility to Public in the Ports tab.

#### 5.3 Akeyless API
```bash
kubectl port-forward svc/gw-akeyless-api-gateway 8081:8081 -n akeyless
```
Remember to set the port visibility to Public in the Ports tab.

#### 5.4 Flask Application
```bash
kubectl port-forward svc/flask-todo 5000:80 -n flask-todo
```

### 6. Login to the Akeyless Gateway UI

This will reset the connection between the Gateway and the Akeyless Console. If you click on the globe icon on the Port `8000` line to open the Akeyless Gateway UI in a new tab and find yourself logged in, please log out and log back in.

Use the credentials in the file `creds_api_key_auth.json` to login to the Akeyless Gateway.

### 7. Login to ArgoCD

- Username: `admin`
- Password: `kubectl get secret -n argocd argocd-initial-admin-secret -o json | jq -r '.data.password' | base64 --decode`

If you find the flask application pod still in a CrashLoopBackOff state, you can restart the pod by deleting it from ArgoCD directly.

### 8. Check the Flask Application UI

Go to the ports section in your codespace and click on the globe icon on the Port `5000` line to open the Flask App in a new tab.

Start interacting with the Flask App by adding and deleting todo items and find the Easter Egg if you haven't already! 🔐

### 9. [Optional] Login to the Akeyless Console

Use the following OIDC Access ID when logging into Akeyless via OIDC (both UI and CLI).
`p-j1ej0z1eudthim`

## Troubleshooting Tips

1. There is some uniquenes to the Akeyless gateway, as per the documentation: Each Gateway instance is uniquely identified by combining the Gateway Access ID Authentication Method and the Cluster Name. It means that changing the Gateway Access ID or the Cluster Name of your Gateway instance will create an entirely new Gateway instance, and it will not retrieve the settings and data from the previous Gateway instance.
2. What that means is that if you change the Gateway Access ID or the Cluster Name of your Gateway instance, you will need to create a new Gateway instance. So first you need delete the following:
  - The old Gateway instance
  - The old Akeyless API acceess id and key
3. Akeyless changed the Helm chart for the API Gateway, so you need to use the new one.
