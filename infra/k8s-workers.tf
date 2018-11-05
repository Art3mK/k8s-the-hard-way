variable "worker_image" {
  default = "ami-03f2ee00e9dc6b85f" # bionic 18.04 LTS
}

variable "worker_instance_type" {
  default = "t3.small"
}

resource "aws_security_group" "workers" {
  name_prefix = "kthw-worker-sg"
  description = "security group for accessing k8s workers"
  vpc_id      = "${module.vpc.vpc_id}"

  tags = {
    Name  = "kthw-workers-sg"
    Owner = "artem.kajalainen"
  }
}

resource "aws_security_group_rule" "ssh_workers" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${data.http.ip.body}/32"]
  security_group_id = "${aws_security_group.workers.id}"
}

resource "aws_security_group_rule" "workers_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.workers.id}"
}

resource "aws_instance" "worker_1" {
  ami                    = "${var.worker_image}"
  instance_type          = "${var.worker_instance_type}"
  key_name               = "artem.kajalainen"
  subnet_id              = "${element(module.vpc.private_subnets, 0)}"
  vpc_security_group_ids = ["${aws_security_group.workers.id}", "${aws_security_group.common.id}"]
  source_dest_check      = "false"

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
  }

  tags = {
    Name  = "kthw-worker-1"
    Owner = "artem.kajalainen"
  }

  volume_tags = {
    Name  = "kthw-worker-1"
    Owner = "artem.kajalainen"
  }
}

resource "aws_instance" "worker_2" {
  ami                    = "${var.worker_image}"
  instance_type          = "${var.worker_instance_type}"
  key_name               = "artem.kajalainen"
  subnet_id              = "${element(module.vpc.private_subnets, 1)}"
  vpc_security_group_ids = ["${aws_security_group.workers.id}", "${aws_security_group.common.id}"]
  source_dest_check      = "false"

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
  }

  tags = {
    Name  = "kthw-worker-2"
    Owner = "artem.kajalainen"
  }

  volume_tags = {
    Name  = "kthw-worker-2"
    Owner = "artem.kajalainen"
  }
}

resource "aws_instance" "worker_3" {
  ami                    = "${var.worker_image}"
  instance_type          = "${var.worker_instance_type}"
  key_name               = "artem.kajalainen"
  subnet_id              = "${element(module.vpc.private_subnets, 2)}"
  vpc_security_group_ids = ["${aws_security_group.workers.id}", "${aws_security_group.common.id}"]
  source_dest_check      = "false"

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
  }

  tags = {
    Name  = "kthw-worker-3"
    Owner = "artem.kajalainen"
  }

  volume_tags = {
    Name  = "kthw-worker-3"
    Owner = "artem.kajalainen"
  }
}
