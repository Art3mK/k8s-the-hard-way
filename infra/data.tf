data "http" "ip" {
  url = "http://ipecho.net/plain"
}

data "aws_route53_zone" "parent" {
  name         = "${var.route53_parent_zone}"
  private_zone = false
}
