# Deploy an App

In this lab we will deploy an app to the EKS cluster from within Port.

- [Deploy an App](#deploy-an-app)
  - [1. Add GitHub Personal Access Token credentials to Akeyless](#1-add-github-personal-access-token-credentials-to-akeyless)
  - [2. Prepare to Scaffold a Nodejs App](#2-prepare-to-scaffold-a-nodejs-app)
  - [3. Run the self-service action](#3-run-the-self-service-action)
  - [4. Deploy the app to the EKS cluster](#4-deploy-the-app-to-the-eks-cluster)

## 1. Add GitHub Personal Access Token credentials to Akeyless

You will need to add your GitHub Personal Access Token credentials to Akeyless. So that Port can issue a GitHub Actions workflow to scaffold an app.

Follow the instructions below to get your GitHub PAT credentials.

1. Go to https://github.com/settings/tokens
2. Click on `Generate new token (classic)`
3. Enter a name for the token, for example `Port-Scaffold-App`
4. Select the `repo` scope
5. Click on `Generate token`
6. Copy the token to your clipboard

![alt text](../images/github-pat.png)


Run the `add_pat_cred.sh` script to add your GitHub PAT credentials to Akeyless.

```bash
Lab06/add_pat_cred.sh
```

## 2. Prepare to Scaffold a Nodejs App

a. Go to the self-service page.

b. Click on the + Action button.

c. Click on the {...} Edit JSON button in the top right corner.

d. Copy and paste the JSON configuration in the port/self-service-actions/scaffold_an_app.json file into the editor.

e. Make sure to REPLACE in 2 places the your_org_name and your_repo_name with your actual organization and repo name. You will find them in the invocationMethod section and in the invocationMethod.workflowInputs.payload.invocationMethod

f. Click Save

## 3. Run the self-service action

This action will create the following:

- A GitHub repository containing a starter Node.js app.
- Since the repository is created with a `port.yml` file, the Port GitHub app will create the repository entity automatically.
- An ECR repository for the app.

Click on the action you just created using the `nodejs` template and click `Execute`.

![alt text](../images/port-scaffold-app.png)

You will see the self-service action running in the UI and will succeed as shown below.

![alt text](../images/port-scaffold-app-success-1.png)

Then you can check the catalog to see the new repo created as shown below.

![alt text](../images/port-scaffold-app-success-2.png)

## 4. Deploy the app to the EKS cluster

On the self-service page, create a Port action using the JSON configuration in the `port/self-service-actions/deploy_to_eks_action.json` file.

Make sure to REPLACE in 2 places the your_org_name and your_repo_name with your actual organization and repo name. You will find them in the invocationMethod section and in the invocationMethod.workflowInputs.payload.invocationMethod

After you create the action, click on it and click `Execute`.

![alt text](../images/port-deploy-to-eks.png)

This self-service action will:

- Build the docker image.
- Push it to the ECR repository.
- Deploy it to the cluster.

> You've reached the end of the lab.

