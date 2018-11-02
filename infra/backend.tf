terraform {
  # remote state and lock with s3 and dynamodb
  backend "s3" {
    bucket = "artemk-tfstate"
    key    = "k8s-the-hard-way.tfstate"
    region = "eu-west-2"
  }
}
