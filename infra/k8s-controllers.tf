variable "controller_image" {
  default = "ami-03f2ee00e9dc6b85f" # bionic 18.04 LTS
}

variable "controller_instance_type" {
  default = "t3.small"
}

resource "aws_security_group" "controllers" {
  name_prefix = "kthw-controller-sg"
  description = "security group for accessing k8s controllers"
  vpc_id      = "${module.vpc.vpc_id}"

  tags = {
    Name  = "kthw-controllers-sg"
    Owner = "artem.kajalainen"
  }
}

resource "aws_security_group_rule" "ssh_controllers" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${data.http.ip.body}/32"]
  security_group_id = "${aws_security_group.controllers.id}"
}

resource "aws_security_group_rule" "ctrl_api" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.controller_1.public_ip}/32", "${aws_instance.controller_2.public_ip}/32", "${aws_instance.controller_3.public_ip}/32"]
  security_group_id = "${aws_security_group.controllers.id}"
}

resource "aws_security_group_rule" "api" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["${data.http.ip.body}/32"]
  security_group_id = "${aws_security_group.controllers.id}"
}

resource "aws_security_group_rule" "health_check" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = "${aws_security_group.controllers.id}"
}

resource "aws_security_group_rule" "workers_to_api_via_lb" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["${element(module.vpc.nat_public_ips, 0)}/32"]
  security_group_id = "${aws_security_group.controllers.id}"
}

resource "aws_security_group_rule" "controllers_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.controllers.id}"
}

resource "aws_instance" "controller_1" {
  ami                    = "${var.controller_image}"
  instance_type          = "${var.controller_instance_type}"
  key_name               = "artem.kajalainen"
  subnet_id              = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids = ["${aws_security_group.controllers.id}", "${aws_security_group.common.id}"]
  source_dest_check      = "false"

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
  }

  tags = {
    Name  = "kthw-controller-1"
    Owner = "artem.kajalainen"
  }

  volume_tags = {
    Name  = "kthw-controller-1"
    Owner = "artem.kajalainen"
  }
}

resource "aws_instance" "controller_2" {
  ami                    = "${var.controller_image}"
  instance_type          = "${var.controller_instance_type}"
  key_name               = "artem.kajalainen"
  subnet_id              = "${element(module.vpc.public_subnets, 1)}"
  vpc_security_group_ids = ["${aws_security_group.controllers.id}", "${aws_security_group.common.id}"]
  source_dest_check      = "false"

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
  }

  tags = {
    Name  = "kthw-controller-2"
    Owner = "artem.kajalainen"
  }

  volume_tags = {
    Name  = "kthw-controller-2"
    Owner = "artem.kajalainen"
  }
}

resource "aws_instance" "controller_3" {
  ami                    = "${var.controller_image}"
  instance_type          = "${var.controller_instance_type}"
  key_name               = "artem.kajalainen"
  subnet_id              = "${element(module.vpc.public_subnets, 2)}"
  vpc_security_group_ids = ["${aws_security_group.controllers.id}", "${aws_security_group.common.id}"]
  source_dest_check      = "false"

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
  }

  tags = {
    Name  = "kthw-controller-3"
    Owner = "artem.kajalainen"
  }

  volume_tags = {
    Name  = "kthw-controller-3"
    Owner = "artem.kajalainen"
  }
}
