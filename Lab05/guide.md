# Build the EKS Cluster

In this lab we will build the EKS cluster from Port.

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Build the EKS Cluster](#build-the-eks-cluster)
  - [1. Commit and Push the Changes](#1-commit-and-push-the-changes)
  - [2. Create an EKS Cluster](#2-create-an-eks-cluster)
  - [3. Check the GitHub Actions Workflow](#3-check-the-github-actions-workflow)
  - [4. Access the Cluster](#4-access-the-cluster)

<!-- /code_chunk_output -->

## 1. Commit and Push the Changes

Before we can create an EKS cluster, we need to commit and push the changes to the repository. Mainly, we need to update the Gateway URL in the GitHub Actions Workflow. The Gateway URL is stored in the file `akeyless_gateway_url.txt` in the root of this repository. The workflow will read this file and use the URL for multiple purposes. In addition to the IAM users added to main.tf.

In a terminal, run the following commands:

```bash
git add .
git commit -m "Update the Gateway URL in the GitHub Actions Workflow"
git push
```

## 2. Create an EKS Cluster

Go to the self-service page and click on the `Create` button under the `Create an EKS Cluster` action. Give it a short name (otherwise EKS may complain) and select the us-east-1 region then click `Execute`.

![alt text](../images/port-create-eks-cluster-execute.png)

You can then see the run progress by clicking the `My latest runs` button at the top right.

![alt text](../images/port-run-progress.png)

## 3. Check the GitHub Actions Workflow

After a few seconds, a GitHub icon will appear and if you click it, it will take you to the GitHub Actions workflow.

![alt text](../images/port-eks-cluster-in-progress.png)

You can check the GitHub actions workflow to see the progress of the run.

![alt text](../images/github-actions-progress.png)

Finally, when the EKS cluster is created (takes about 15 minutes), you will see it in the Port UI.

![alt text](../images/port-eks-cluster-success.png)

## 4. Access the Cluster

To get the kubeconfig for the cluster, run the command below replacing <your-eks-cluster-name> with your eks cluster name which will show up in the Port UI as shown in the two screenshots below:

![alt text](../images/port-eks-cluster-catalog-1.png)

![alt text](../images/port-eks-cluster-catalog-2.png)

Run the following command:

```bash
aws eks update-kubeconfig --region us-east-1 --role-arn arn:aws:iam::047709130171:role/github-actions-eks-role --name <your-eks-cluster-name>
```

> Note: If after you run the pipeline and find that you get an error accessing the cluster, it could be that you need to refresh the AWS credentials you're using, that is if you are using the ones provided by TeKanAid Academy. You can refresh them by running the command: `Lab01/start.sh` again.

You can now use `kubectl` to access the cluster.

Below are some suggested commands for you to run.

```bash
kubens # alias for kubectl get namespaces
```

Output:
```
default
kube-node-lease
kube-public
kube-system
```

```bash
kubens kube-system # to switch to the kube-system namespace
```

Output:
```
Context "arn:aws:eks:us-east-1:047709130171:cluster/workshop-1-AYEsefOJ" modified.
Active namespace is "kube-system".
```

```bash
kga # alias for kubectl get all
```

Output:
```
NAME                           READY   STATUS    RESTARTS   AGE
pod/aws-node-pt7dj             2/2     Running   0          99s
pod/aws-node-t8m4c             2/2     Running   0          97s
pod/coredns-789f8477df-c9t94   1/1     Running   0          5m50s
pod/coredns-789f8477df-qcdzl   1/1     Running   0          5m50s
pod/kube-proxy-7fvrx           1/1     Running   0          97s
pod/kube-proxy-jjs7j           1/1     Running   0          99s

NAME                                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
service/eks-extension-metrics-api   ClusterIP   172.20.205.255   <none>        443/TCP                  7m54s
service/kube-dns                    ClusterIP   172.20.0.10      <none>        53/UDP,53/TCP,9153/TCP   5m51s

NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/aws-node     2         2         2       2            2           <none>          5m50s
daemonset.apps/kube-proxy   2         2         2       2            2           <none>          5m51s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/coredns   2/2     2            2           5m51s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/coredns-789f8477df   2         2         2       5m51s
```

> You've reached the end of the lab.
