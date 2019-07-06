# This code involves setting up jenkins master and jenkins slave using terraform  code in public VPC

We create and launch VPC. Setup public subnetes.
Launch jenkins master 1 node and jenkins slave 1 node in 1 subnet

To execute code git clone the repo
cd ~/work/myprojects/terraform-jenkins-masterslave/terraform/environment/demo

terraform init

Can provide any .pem keys. Edit demo/deploy.tf to change parameters

terraform plan --var "jenkins_install=/home/aditiw/work/myprojects/terraform-jenkins-masterslave/terraform/module/application/jenkins/jenkins-master-install.tpl" --var "ssh_key_path=~/.ssh/CoreOS-K8.pem"


terraform apply --var "jenkins_install=/home/aditiw/work/myprojects/terraform-jenkins-masterslave/terraform/module/application/jenkins/jenkins-master-install.tpl" --var "ssh_key_path=~/.ssh/CoreOS-K8.pem"
