output "controller_1_public_ip" {
  value = "${aws_instance.controller_1.public_ip}"
}

output "controller_2_public_ip" {
  value = "${aws_instance.controller_2.public_ip}"
}

output "controller_3_public_ip" {
  value = "${aws_instance.controller_3.public_ip}"
}
