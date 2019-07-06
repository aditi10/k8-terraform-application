resource "aws_security_group" "k8_sg" {
	tags {
    		Name 	= "${var.env}_k8_sg"
  	}
	name		= "${var.env}_k8_sg"
	description 	= "Security group for k8-${var.env}"
	vpc_id 		= "${aws_vpc.dmz.id}"
}


resource "aws_security_group_rule" "inbound_k8self_sg_9000" {
        type = "ingress"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_group_id = "${aws_security_group.k8_sg.id}"
}
/*
resource "aws_security_group_rule" "inbound_k8_allow_all_internalIP" {
        type = "ingress"
        from_port = 0
        to_port = 0
        protocol = "-1"
        source_security_group_id = "${aws_security_group.k8_sg.id}"
        security_group_id = "${aws_security_group.k8_sg.id}"
}
*/
/*
resource "aws_security_group_rule" "inbound_k8self_ICMP" {
        type = "ingress"
        from_port = 8
        to_port = 0
        protocol = "icmp"
        source_security_group_id = "${aws_security_group.k8_sg.id}"
#	source_security_group_id = "${aws_security_group.ICPM_allow_all_sg.id}"
        security_group_id = "${aws_security_group.k8_sg.id}"
}*/
resource "aws_security_group_rule" "inbound_k8_ssh" {
        type = "ingress"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_group_id = "${aws_security_group.k8_sg.id}"
}





# Allow outbound

resource "aws_security_group_rule" "outbound_k8_allow_all" {
        type = "egress"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        security_group_id = "${aws_security_group.k8_sg.id}"
}


