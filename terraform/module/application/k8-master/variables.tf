variable "ami_id" {}
# variable "ssh_key_path" {}
#variable "jenkins_install" {}
variable "az" {}
variable "az_var" {}
variable "instance_name" {}
variable "env" {}
variable "number_instances" {}
variable "key_name" {}
# variable "iam" {}
variable "aws_security_group" {}
# variable "org_validator" {}
#variable "bastion_user" {}
# variable "bastion_host" {}
# variable "organization" {}
/*
variable "vpc_security_group_ids" {
	type = "list"
}
*/
variable "subnet_id" {}
/*
variable "tag_name" {
	default = {
	"0"	= "kafka00"
	"1"	= "kafka01"
	}
}
*/

variable "tags" {
  default = {
    created_by = "terraform"
  }
}

variable "instance_type" {}

//ALL BELOW CODE IS COMMENTED
/*
variable "ami" {}

variable "instance_type" {
	default = {
	"0"	= "t2.small"
	"1"	= "t2.small"
	"2"	= "t2.small"
	"3"	= "m4.xlarge"
	"4"	= "t2.medium"
	"5"     = "t2.medium"
	"6"     = "t2.medium"
	"7"     = "t2.medium"
	"8"     = "t2.medium"
	"9"     = "t2.medium"
	"10"     = "t2.medium"
	"11"     = "t2.medium"
	}
}

variable "tag_name" {
	default = {
	"0"	= "publisher-portal-server"
	"1"     = "nginx"
        "2"     = "jenkins"
        "3"     = "memsql-aggregator"
	"4"	= "mediation-server"
	"5"	= "kafka00"
	"6"	= "kafka01"
	"7"	= "mysql"
	"8"	= "tracking-server"
	"9"	= "consumer"
	"10"	= "stat-server"
	"11"	= "priority-enigne"
        }
}



variable "instance_type_large" {}


variable "tag_name_t2medium" {
	type	= "list"
	default =["mediation-server", "kafka", "mysql","tracking-server","consumer","stat-server","priority-enigne"]
}

variable "tag_name_t2small" {
	type    = "list"
        default =["publisher-portal-server", "nginx", "jenkins"]
}

variable "tag_name_m4xlarge" {
	default = "memsql-aggregator"
} */
variable "zone_id_public" {}
