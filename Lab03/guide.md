# Prepare the GitHub Actions Pipeline

In this lab we will get our pipeline ready and make sure we have the Akeyless plugin for GitHub Actions set up to retrieve the AWS Dynamic secret from the previous lab. This allows Terraform to use these AWS credentials to provision our EKS cluster in AWS.


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Prepare the GitHub Actions Pipeline](#prepare-the-github-actions-pipeline)
  - [1. Create an OAuth2.0/JWT Authentication Method for GitHub](#1-create-an-oauth20jwt-authentication-method-for-github)
  - [2. Add the Access ID as a GitHub Repository Variable](#2-add-the-access-id-as-a-github-repository-variable)
  - [3. Create an Access Role](#3-create-an-access-role)
  - [4. Associate the Authentication Method with an Access Role](#4-associate-the-authentication-method-with-an-access-role)
  - [5. Set Read permissions for our AWS Dynamic Secret for the Access Role](#5-set-read-permissions-for-our-aws-dynamic-secret-for-the-access-role)
  - [6. Enable Workflows in your Repo](#6-enable-workflows-in-your-repo)

<!-- /code_chunk_output -->



## 1. Create an OAuth2.0/JWT Authentication Method for GitHub

We need to create an authentication method in Akeyless for GitHub. This is a way for GitHub to authenticate to Akeyless and retrieve the AWS credentials. We will use the JWT method so we don't have to hard-code API keys for Akeyless in GitHub. This is an elegant solution to solve the secret zero problem which is the first secret needed to retreive all other secrets.

Run the commands below:

```bash
akeyless configure --profile default --access-id "$(jq -r .access_id creds_api_key_auth.json)" --access-key "$(jq -r .access_key creds_api_key_auth.json)"
akeyless auth-method create oauth2 \
--name /Workshops/Akeyless-Workshop-1/GitHubAuthWorkshop \
--jwks-uri https://token.actions.githubusercontent.com/.well-known/jwks \
--unique-identifier repository \
--force-sub-claims
```

Save the output Access ID as we will use it in the next step to store it as a GitHub Rpository Variable. I got `p-ankhb1k27xkfom` as an example access id.

## 2. Add the Access ID as a GitHub Repository Variable

You can store the Access ID as a GitHub variable inside the repository to use in your workflow.

In the following examples, instead of explicitly specifying the Access ID of the Authentication Method inside the workflow, we store it as a variable in the repository called `AKEYLESS_ACCESS_ID`.

On GitHub, navigate to the main page of the repository, and select Settings > Secrets and variables > Actions > Variables tab > New repository variable.
Enter the name for the variable as `AKEYLESS_ACCESS_ID` and set the value to your Auth Method Access ID.

Select Add Variable.

![alt text](../images/repo_variable.png)

## 3. Create an Access Role

Run the command below:

```bash
akeyless create-role --name /Workshops/Akeyless-Workshop-1/GitHubRoleWorkshop
```

## 4. Associate the Authentication Method with an Access Role

Run the command below, but first update your repository for `sub-claims`. This makes sure that the GitHub repository name is included in the JWT token.

```bash
akeyless assoc-role-am --role-name /Workshops/Akeyless-Workshop-1/GitHubRoleWorkshop \
--am-name /Workshops/Akeyless-Workshop-1/GitHubAuthWorkshop  \
--sub-claims repository=<octo-org>/port-akeyless-workshop-1 # REPLACE <octo-org> with your github username, my repop ends up looking like this: samgabrail/port-akeyless-workshop-1
```

## 5. Set Read permissions for our AWS Dynamic Secret for the Access Role

```bash
akeyless set-role-rule --role-name /Workshops/Akeyless-Workshop-1/GitHubRoleWorkshop \
--path /Workshops/Akeyless-Workshop-1/* \
--capability read
```

## 6. Enable Workflows in your Repo

Since you've forked this repo, you need to enable the GitHub Actions workflows. Go to the Actions tab and click the button `I understand my workflows, go ahead and enable them`.

![alt text](../images/enable_workflows.png)

> You've reached the end of the lab.