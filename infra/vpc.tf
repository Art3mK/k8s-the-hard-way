data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "art3mk-k8s-the-hard-way"
  cidr = "${var.vpc_cidr}"

  azs = ["${data.aws_availability_zones.available.names}"]

  private_subnets = [
    "10.134.0.0/22",
    "10.134.4.0/22",
    "10.134.8.0/22",
  ]

  public_subnets = [
    "10.134.128.0/22",
    "10.134.132.0/22",
    "10.134.136.0/22",
  ]

  enable_nat_gateway     = true
  enable_dns_hostnames   = true
  enable_dns_support     = true
  one_nat_gateway_per_az = false
  single_nat_gateway     = true

  tags = {
    Owner   = "Artem Kajalainen"
    Project = "k8s-the-hard-way"
  }
}
