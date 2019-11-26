
variable "aws-region" {
  default = "us-east-1"
}

variable "cluster-name" {
  default = "eks_tf_demo"
}

variable "availability-zones" {
  type = list
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
}

variable "k8s-version" {
  default = "1.13"
}

variable "node-instance-type" {
  default = "t2.small"
}

variable "root-block-size" {
  default = 40
}

variable "desired-capacity" {
  default = 3
}

variable "max-size" {
  default = 5
}

variable "min-size" {
  default = 1
}

variable "public-min-size" {
  default = 1
}

variable "public-max-size" {
  default = 5
}

variable "public-desired-capacity" {
  default = 3
}

variable "kublet-extra-args" {
  default = ""
}

variable "public-kublet-extra-args" {
  default = ""
}

variable "vpc-subnet-cidr" {
  default = "10.0.0.0/16"
}

variable "private-subnet-cidr" {
  type = list
  default = ["10.0.0.0/19",
    "10.0.32.0/19",
    "10.0.64.0/19"
  ]

}

variable "public-subnet-cidr" {
  type = list
  default = [
    "10.0.128.0/20",
    "10.0.144.0/20",
    "10.0.160.0/20"
  ]
}

variable "db-subnet-cidr" {
  type = list
  default = [
    "10.0.192.0/21",
    "10.0.200.0/21",
    "10.0.208.0/21"
  ]
}

variable "eks-cw-logging" {
  type    = list
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "ec2-key-public-key" {
  default = ""
}
