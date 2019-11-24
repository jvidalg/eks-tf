
variable "aws-region" {}

variable "cluster-name" {}

variable "availability-zones" {
    type = list
}

variable "k8s-version" {}

variable "node-instance-type" {}

variable "root-block-size" {}

variable "desired-capacity" {}

variable "max-size" {}

variable "min-size" {}

variable "public-min-size" {}

variable "public-max-size" {}

variable "public-desired-capacity" {}

variable "kublet-extra-args" {}

variable "public-kublet-extra-args" {}

variable "vpc-subnet-cidr" {}

variable "private-subnet-cidr" {
    type = list
}

variable "public-subnet-cidr" {
    type = list
}

variable "db-subnet-cidr" {
    type = list
}

variable "eks-cw-logging" {
    type = list
}

variable "ec2-key-public-key" {}
