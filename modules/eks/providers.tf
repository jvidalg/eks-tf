####################
# Setup providers
####################
variable "aws-region" {}

provider "aws" {
  region = var.aws-region
}

provider "http" {}

provider "helm" {}
