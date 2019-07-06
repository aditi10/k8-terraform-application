# k8-terraform-application
Create an application where infra is spawned using terraform, kubespray, helm, prometheus and grafana


Workstation Prerequisite
1. Create an AWS account
2. Configure vi ~/.aws/credentials
3. Configure Terraform
4. Configure Ansible
5. Configure kubectl
 


TERRAFORM

Using terraform spawn a 3 Node K8 CLuster
git clone git@github.com:aditi10/k8-terraform-application.git

cd terraform/environment/demo/env.tf file. 
Edit AWS region s3 bucket according to needs

This script creates a VPC, subnet, IGW,3 nodes, Security Groups, route 53 enteries,  on AWS. Instance type, key_name, ami_id, availability zones and Instance size can be updated by editing terraform/environment/demo/deploy.tf

terraform init
terraform plan
terraform apply


KUBESPRAY
WAY2- Install Kubernetes cluster containing 2 Masters, 3 etcd, 3 nodes cluster  using kubespray

Git clone https://github.com/kubernetes-sigs/kubespray.git
sudo pip install -r requirements.txt
https://github.com/kubernetes-sigs/kubespray
declare -a IPS=(34.242.21.35  54.171.219.9 34.244.54.89) . Provide Public IP's of AWS cluster

CONFIG_FILE=inventory/mycluster/hosts.yml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
# Review and change parameters under ``inventory/mycluster/group_vars``
cat inventory/mycluster/group_vars/all/all.yml
cat inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml

ansible-playbook -i inventory/mycluster/hosts.yml --become --become-user=root cluster.yml --flush-cache

ssh into 1 of the nodes
sudo su -

kubectl get nodes



Create a CI/CD pipeline using Jenkins (or a CI tool of your choice) outside Kubernetes cluster (not as a pod inside Kubernetes cluster).
Spawn Jenkins server on one of the k8 masters


