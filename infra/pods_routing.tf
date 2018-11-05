resource "aws_route" "pods_worker_1" {
  route_table_id         = "${element(module.vpc.private_route_table_ids, 0)}"
  destination_cidr_block = "10.200.1.0/24"
  instance_id            = "${aws_instance.worker_1.id}"
}

resource "aws_route" "pods_worker_2" {
  route_table_id         = "${element(module.vpc.private_route_table_ids, 0)}"
  destination_cidr_block = "10.200.2.0/24"
  instance_id            = "${aws_instance.worker_2.id}"
}

resource "aws_route" "pods_worker_3" {
  route_table_id         = "${element(module.vpc.private_route_table_ids, 0)}"
  destination_cidr_block = "10.200.3.0/24"
  instance_id            = "${aws_instance.worker_3.id}"
}
