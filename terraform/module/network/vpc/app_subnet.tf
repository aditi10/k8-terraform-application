resource "aws_subnet" "app_subnet" {
  vpc_id            = "${aws_vpc.dmz.id}"
  cidr_block        = "${element(split(",", var.public_ranges), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count             = "${length(compact(split(",", var.public_ranges)))}"

  tags {
    Name = "${var.env}-${element(split(",", var.azs), count.index)}-${var.env_pub}"
  }
  map_public_ip_on_launch = true
}

resource "aws_route_table" "app_public_rt" {
  vpc_id = "${aws_vpc.dmz.id}"
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dmz_igw.id}"
}
  tags {
    Name = "${var.application_short}-${var.env}-${var.env_pub}-${element(split(",", var.small_az), count.index)}"
  }
}

resource "aws_route_table_association" "rt" {
    subnet_id = "${aws_subnet.app_subnet.0.id}"
    route_table_id = "${aws_route_table.app_public_rt.id}"
}

resource "aws_route_table_association" "rt1" {
    subnet_id = "${aws_subnet.app_subnet.1.id}"
    route_table_id = "${aws_route_table.app_public_rt.id}"
}