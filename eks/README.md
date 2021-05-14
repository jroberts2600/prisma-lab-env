# Provision an EKS Cluster

Terraform configuration files to provision an EKS cluster on AWS.

After deployment, obtain EKS credentials:
aws eks --region <REGION> update-kubeconfig --name <EKS CLUSTER NAME>
