resource "aws_route53_record" "k8-route-53-public" {
  zone_id = "${var.zone_id_public}"
  name    = "${var.instance_name}-${format("%03d",count.index)}-${element(split(",", var.az_var), count.index)}"
  type    = "CNAME"
  ttl     = "60"
  count   = "${var.number_instances}"
  records = ["${element(aws_instance.ec2_k8.*.public_dns, count.index)}"]
}
