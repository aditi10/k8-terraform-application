output "vpc_id" {
        value = "${aws_vpc.dmz.id}"
}

output "k8_public_subnet_id" {
#	value = "${aws_subnet.app_subnet.id}" 
	value = "${join(",", aws_subnet.app_subnet.*.id)}"
}

output "k8_sg_id" {
        value = "${aws_security_group.k8_sg.id}"
}
