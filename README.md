# terraform-aws-eks

Customized EKS cluster provisioned with Terraform based on:
[![TerraformRefigistry](https://img.shields.io/badge/Terraform%20Registry-version_2-blue.svg)](https://registry.terraform.io/modules/WesleyCharlesBlake/eks/aws/)

```
tree                                                 
.
├── LICENSE
├── README.md
├── backend
│   ├── main.tf
│   ├── terraform.tfstate
│   └── variables.tf
├── envs
│   └── dev
│       ├── main.tf
│       ├── outputs.tf
│       ├── terraform.tfstate
│       ├── terraform.tfstate.backup
│       ├── terraform.tfvars
│       └── variables.tf
├── modules
│   └── eks
│       ├── bastion.tf
│       ├── config.tf
│       ├── data.tf
│       ├── ec2-key.tf
│       ├── eks-cluster.tf
│       ├── eks-worker-nodes-public.tf
│       ├── eks-worker-nodes.tf
│       ├── iam.tf
│       ├── network.tf
│       ├── providers.tf
│       ├── sec-groups.tf
│       └── workstation-external-ip.tf
└── versions.tf
```

Added **backend** directory to provision s3 and dynamo table if there was none previously available.
Added **env** to separate environments and set custom values according each one needs.

Deploy a full AWS EKS cluster with Terraform

## What resources are created

1. VPC
2. Internet Gateway (IGW)
3. Public and Private Subnets
4. Security Groups, Route Tables and Route Table Associations
5. IAM roles, instance profiles and policies
6. An EKS Cluster
7. Autoscaling group and Launch Configuration
8. Worker Nodes in a private Subnet
9. bastion host for ssh access to the VPC
10. The ConfigMap required to register Nodes with EKS
11. KUBECONFIG file to authenticate kubectl using the `aws eks get-token` command. needs awscli version `1.16.156 >`

## Remote Terraform Module

> **NOTE** use `version = "2.0.0"` with terraform `0.12.x >` and `version = 1.0.4` with terraform `< 0.11x`

Have a look at the [examples](examples) for complete references
You can use this module from the Terraform registry as a remote source:



### IAM

The AWS credentials must be associated with a user having at least the following AWS managed IAM policies

* IAMFullAccess
* AutoScalingFullAccess
* AmazonEKSClusterPolicy
* AmazonEKSWorkerNodePolicy
* AmazonVPCFullAccess
* AmazonEKSServicePolicy
* AmazonEKS_CNI_Policy
* AmazonEC2FullAccess

In addition, you will need to create the following managed policies

*EKS*

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        }
    ]
}
```

### Terraform

For implementation examples, go to env directory and look at any of the available environments.

### Setup kubectl

Setup your `KUBECONFIG`

```bash
terraform output kubeconfig > ~/.kube/eks-cluster
export KUBECONFIG=~/.kube/eks-cluster
```

### Authorize worker nodes

Get the config from terraform output, and save it to a yaml file:

```bash
terraform output config-map > config-map-aws-auth.yaml
```

Configure aws cli with a user account having appropriate access and apply the config map to EKS cluster:

```bash
kubectl apply -f config-map-aws-auth.yaml
```

You can verify the worker nodes are joining the cluster

```bash
kubectl get nodes --watch
```

### Authorize users to access the cluster

Initially, only the system that deployed the cluster will be able to access the cluster. To authorize other users for accessing the cluster, `aws-auth` config needs to be modified by using the steps given below:

* Open the aws-auth file in the edit mode on the machine that has been used to deploy EKS cluster:

```bash
sudo kubectl edit -n kube-system configmap/aws-auth
```

* Add the following configuration in that file by changing the placeholders:


```yaml

mapUsers: |
  - userarn: arn:aws:iam::111122223333:user/<username>
    username: <username>
    groups:
      - system:masters
```

So, the final configuration would look like this:

```yaml
apiVersion: v1
data:
  mapRoles: |
    - rolearn: arn:aws:iam::555555555555:role/devel-worker-nodes-NodeInstanceRole-74RF4UBDUKL6
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::111122223333:user/<username>
      username: <username>
      groups:
        - system:masters
```

* Once the user map is added in the configuration we need to create cluster role binding for that user:

```bash
kubectl create clusterrolebinding ops-user-cluster-admin-binding-<username> --clusterrole=cluster-admin --user=<username>
```
Replace the placeholder with proper values

### Cleaning up

You can destroy this cluster entirely by running:

```bash
terraform plan -destroy
terraform destroy  --force
```
