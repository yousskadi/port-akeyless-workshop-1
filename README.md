# Overview
A Repo for the Hands-On Workshop for Platform Engineers: End-to-End Secure Deployment of an App on EKS with Port and Akeyless

## High-Level Workflow Steps
1. Create an EKS cluster from Port
2. Scaffold a Node.js app from Port
3. Build and deploy the Node.js app to the EKS cluster from Port


## Troubleshooting Tips

1. There is some uniquenes to the Akeyless gateway, as per the documentation: Each Gateway instance is uniquely identified by combining the Gateway Access ID Authentication Method and the Cluster Name. It means that changing the Gateway Access ID or the Cluster Name of your Gateway instance will create an entirely new Gateway instance, and it will not retrieve the settings and data from the previous Gateway instance.
2. What that means is that if you change the Gateway Access ID or the Cluster Name of your Gateway instance, you will need to create a new Gateway instance. So first you need delete the following:
  - The old Gateway instance
  - The old Akeyless API acceess id and key
3. Akeyless changed the Helm chart for the API Gateway, so you need to use the new one.
