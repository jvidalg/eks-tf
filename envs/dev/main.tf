### VPC

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "tf-remote-state-bucket-eks-cluster"
    key            = "envs/dev/terraform.tfstate"
    dynamodb_table = "terraform-state-lock-dynamo-eks-cluster"
    region         = "us-east-1"
  }
}


module "eks" {
  source = "../../modules/eks"

  aws-region               = var.aws-region
  availability-zones       = var.availability-zones
  cluster-name             = var.cluster-name
  k8s-version              = var.k8s-version
  node-instance-type       = var.node-instance-type
  root-block-size          = var.root-block-size
  desired-capacity         = var.desired-capacity
  max-size                 = var.max-size
  min-size                 = var.min-size
  public-min-size          = var.public-min-size
  public-max-size          = var.public-max-size
  public-desired-capacity  = var.public-desired-capacity
  kublet-extra-args        = var.kublet-extra-args
  public-kublet-extra-args = var.public-kublet-extra-args
  vpc-subnet-cidr          = var.vpc-subnet-cidr
  private-subnet-cidr      = var.private-subnet-cidr
  public-subnet-cidr       = var.public-subnet-cidr
  db-subnet-cidr           = var.db-subnet-cidr
  eks-cw-logging           = var.eks-cw-logging
  ec2-key-public-key       = var.ec2-key-public-key

}

