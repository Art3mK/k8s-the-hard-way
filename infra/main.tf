provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "common" {
  name_prefix = "kthw-common-sg-"
  description = "controllers-workers-sg"
  vpc_id      = "${module.vpc.vpc_id}"

  tags = {
    Name  = "kthw-controllers-workers-sg"
    Owner = "artem.kajalainen"
  }
}

resource "aws_security_group_rule" "common" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = "true"
  security_group_id = "${aws_security_group.common.id}"
}

resource "aws_security_group_rule" "common_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.common.id}"
}

resource "aws_route53_zone" "kthw" {
  name    = "kthw.${var.route53_parent_zone}"
  comment = "public kthw.${var.route53_parent_zone} zone"

  tags {
    Name  = "kthw.${var.route53_parent_zone}"
    Owner = "artem.kajalainen"
  }
}

resource "aws_route53_record" "kthw" {
  zone_id = "${data.aws_route53_zone.parent.zone_id}"
  name    = "kthw.${var.route53_parent_zone}"
  type    = "NS"
  ttl     = "60"

  records = [
    "${aws_route53_zone.kthw.name_servers.0}",
    "${aws_route53_zone.kthw.name_servers.1}",
    "${aws_route53_zone.kthw.name_servers.2}",
    "${aws_route53_zone.kthw.name_servers.3}",
  ]
}

resource "aws_route53_record" "api" {
  zone_id = "${aws_route53_zone.kthw.zone_id}"
  name    = "api"
  type    = "A"

  alias {
    name                   = "${aws_lb.api.dns_name}"
    zone_id                = "${aws_lb.api.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_security_group" "lb_sg" {
  name_prefix = "kthw-lb-sg-"
  description = "LB sg"
  vpc_id      = "${module.vpc.vpc_id}"

  tags = {
    Name  = "kthw-lb-sg"
    Owner = "artem.kajalainen"
  }
}

# resource "aws_security_group_rule" "lb_sg_http" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "TCP"
#   cidr_blocks       = ["${data.http.ip.body}/32"]
#   security_group_id = "${aws_security_group.lb_sg.id}"
# }

# resource "aws_security_group_rule" "lb_sg_https" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "TCP"
#   cidr_blocks       = ["${data.http.ip.body}/32"]
#   security_group_id = "${aws_security_group.lb_sg.id}"
# }

# resource "aws_security_group_rule" "lb_sg_egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = "${aws_security_group.lb_sg.id}"
# }

resource "aws_lb" "api" {
  name_prefix        = "kthw-"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${module.vpc.public_subnets}"]
}

resource "aws_lb_target_group" "api_servers" {
  name_prefix = "kthw-"
  port        = 6443
  protocol    = "TCP"
  vpc_id      = "${module.vpc.vpc_id}"
}

resource "aws_lb_target_group_attachment" "ctrl_1" {
  target_group_arn = "${aws_lb_target_group.api_servers.arn}"
  target_id        = "${aws_instance.controller_1.id}"
}

resource "aws_lb_target_group_attachment" "ctrl_2" {
  target_group_arn = "${aws_lb_target_group.api_servers.arn}"
  target_id        = "${aws_instance.controller_2.id}"
}

resource "aws_lb_target_group_attachment" "ctrl_3" {
  target_group_arn = "${aws_lb_target_group.api_servers.arn}"
  target_id        = "${aws_instance.controller_3.id}"
}

resource "aws_lb_listener" "k8s_api" {
  load_balancer_arn = "${aws_lb.api.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.api_servers.arn}"
  }
}
