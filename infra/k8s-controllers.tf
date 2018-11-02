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

data "http" "ip" {
  url = "http://ipecho.net/plain"
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${data.http.ip.body}/32"]
  security_group_id = "${aws_security_group.controllers.id}"
}

resource "aws_instance" "controller_1" {
  ami                    = "${var.controller_image}"
  instance_type          = "${var.controller_instance_type}"
  key_name               = "artem.kajalainen"
  subnet_id              = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids = ["${aws_security_group.controllers.id}"]

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
  vpc_security_group_ids = ["${aws_security_group.controllers.id}"]

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
  vpc_security_group_ids = ["${aws_security_group.controllers.id}"]

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
