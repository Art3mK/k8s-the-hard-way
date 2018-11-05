output "controller_1_public_ip" {
  value = "${aws_instance.controller_1.public_ip}"
}

output "controller_2_public_ip" {
  value = "${aws_instance.controller_2.public_ip}"
}

output "controller_3_public_ip" {
  value = "${aws_instance.controller_3.public_ip}"
}

output "controller_1_private_ip" {
  value = "${aws_instance.controller_1.private_ip}"
}

output "controller_2_private_ip" {
  value = "${aws_instance.controller_2.private_ip}"
}

output "controller_3_private_ip" {
  value = "${aws_instance.controller_3.private_ip}"
}

output "nat_gw_ip" {
  value = "${element(module.vpc.nat_public_ips, 0)}"
}

output "worker-1-ip" {
  value = "${aws_instance.worker_1.private_ip}"
}

output "worker-2-ip" {
  value = "${aws_instance.worker_2.private_ip}"
}

output "worker-3-ip" {
  value = "${aws_instance.worker_3.private_ip}"
}

output "api_public_dns_name" {
  value = "${aws_route53_record.api.fqdn}"
}
