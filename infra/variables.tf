variable "region" {
  default = "eu-west-2"
}

variable "vpc_cidr" {
  default = "10.134.0.0/16"
}

variable "route53_parent_zone" {
  type = "string"
}
