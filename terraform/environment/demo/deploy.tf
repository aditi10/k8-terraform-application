
module "vpc" {
	source				= "../../module/network/vpc"
	env                         	= "test"
	region                      	= "eu-west-1"
	usecase                     	= "MyVPC"
	usecase1                    	= "nat_gw"
	application_short           	= "MyVPC"
	env_pub                     	= "public"
#	env_pvt                     	= "private"
#	env_lb                          = "elb"
	rt                          	= "route-table"
	cidr                        	= "10.0.0.0/16"
	small_az                    	= "a"
	azs                         	= "eu-west-1a,eu-west-1b,eu-west-1c"
	public_ranges			= "10.0.4.0/24,10.0.5.0/24"
	nat_gw_range                	= "10.0.11.0/24"
        enable_dns_support              = "true"
        enable_dns_hostnames            = "true"
#	zone_id_private                 = "ZBRP85RXFTWT8"
#       zone_id_public                  = "Z20X2MO4VN3QGD"
}


module "k8-master" {
        source                          = "../../module/application/k8-master"
        ami_id                          = "ami-08d658f84a6d84a80"
        az                              = "eu-west-1a,eu-west-1b"
	az_var                          = "a,b"
        number_instances                = 3
        key_name                        = "it-test-key"
        aws_security_group              = "${module.vpc.k8_sg_id}"
#       vpc_security_group_ids          = ["vpc-d65310b0","vpc-d65310b0"]
#	subnet_id			= "subnet-4cf3e817"
        subnet_id                       = "${module.vpc.k8_public_subnet_id}"
#        tag_name                       = "mysql-000"
        instance_type                   = "t2.small"
        instance_name                   = "k8-master"
#	iam				= "${module.iam.aws_iam_instance_profile_jenkins_id}"
        env                             = "test"
#        ssh_key_path                    = "${var.ssh_key_path}"
#	ssh_key_path			= "~/.ssh/it-test-key.pem"
	zone_id_public			= "Z1XCXSN8D1O9T7"
#	bastion_host                    = "${module.bastion.bastion_public_ip}"
#        bastion_user                    = "ubuntu"
#        organization                    = "playwing"
#        org_validator                   = "aditiwadekar"
} 

