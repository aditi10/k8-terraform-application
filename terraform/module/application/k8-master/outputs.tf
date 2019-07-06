
/*
output "k8_private_dns" {
  value = "${aws_instance.ec2_k8.private_dns}"
}
*/
output "k8_instance_id" {
  value = ["${aws_instance.ec2_k8.*.id}"]
}

output "private_ip" {
  value = "${aws_instance.ec2_k8.*.private_ip}"
}

output "public_ip"  {
  value = "${aws_instance.ec2_k8.*.public_ip}"
}
