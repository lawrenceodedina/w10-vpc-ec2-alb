terraform {
  backend "s3" {
    bucket         = "hdvbhfbahbvb" #replace with s3 bucket
    key            = "week10/terraform.tf.state"
    region         = "us-east-1"
    dynamodb_table = "locktable"
    encrypt        = true
  }
}
