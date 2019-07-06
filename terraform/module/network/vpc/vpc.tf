resource "aws_vpc" "dmz"
 {
	cidr_block           = "${var.cidr}"
	enable_dns_hostnames = "${var.enable_dns_hostnames}"
 	enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name = "${var.application_short}-${var.env}-${var.region}"
  }
}


resource "aws_internet_gateway" "dmz_igw" {
	vpc_id = "${aws_vpc.dmz.id}"

	tags {
    		Name = "${var.application_short}-${var.env}-${var.region}-igw"
  	}
}

resource "aws_route_table" "dmz_rt" {
	vpc_id = "${aws_vpc.dmz.id}"
	route {
    		cidr_block = "0.0.0.0/0"
    		gateway_id = "${aws_internet_gateway.dmz_igw.id}"
	}
  tags {
    Name = "${var.usecase}-${var.env}-${var.rt}"
  }
}

/* COMMENTED FROM HERE
resource "aws_eip" "nat_eip" {
  count = "${length(split(",", var.nat_gw_range))}"
  vpc   = true
}


resource "aws_subnet" "nat_gw_subnet" {
  vpc_id            = "${aws_vpc.dmz.id}"
  cidr_block        = "${element(split(",", var.nat_gw_range), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count             = "${length(compact(split(",", var.nat_gw_range)))}"

  tags {
    Name = "${var.env}-${element(split(",", var.azs), count.index)}-${var.usecase1}"
  }

  map_public_ip_on_launch = true
}


resource "aws_nat_gateway" "nat_gw" {
  count         = "${length(split(",", var.nat_gw_range))}"
  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.nat_gw_subnet.*.id, count.index)}"
#  subnet_id	= "${element(aws_subnet.app_subnet.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.dmz_igw"]
}



resource "aws_route_table" "nat_gw_rt" {
  vpc_id = "${aws_vpc.dmz.id}"
#  subnet_id = ["${aws_subnet.nat_gw_subnet.id}"]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dmz_igw.id}"
  }
  depends_on             = ["aws_internet_gateway.dmz_igw"]
  tags {
    Name = "${var.usecase1}-${var.env}-${var.rt}"
  }
}


resource "aws_route" "nat_igw_route" {
  route_table_id	 ="${aws_route_table.nat_gw_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.dmz_igw.id}"
  depends_on             = ["aws_internet_gateway.dmz_igw","aws_route_table.nat_gw_rt"]
} */
