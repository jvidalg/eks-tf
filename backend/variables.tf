variable "s3_bucket_name" {
  default = "tf-remote-state-bucket-eks-cluster"
}

variable "dynamodb_table_name" {
  default = "terraform-state-lock-dynamo-eks-cluster"
}