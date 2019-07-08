# k8-terraform-application
Create an application where infra is spawned using terraform, kubespray, helm, prometheus and grafana


Workstation Prerequisite
1. Create an AWS account
2. Configure vi ~/.aws/credentials
3. Configure Terraform
4. Configure Ansible
5. Configure kubectl
 
# TERRAFORM

Using terraform spawn a 3 Node K8 CLuster
git clone git@github.com:aditi10/k8-terraform-application.git

cd terraform/environment/demo/env.tf file. 
Edit AWS region s3 bucket according to needs

This script creates a VPC, subnet, IGW,3 nodes, Security Groups, route 53 enteries,  on AWS. Instance type, key_name, ami_id, availability zones and Instance size can be updated by editing terraform/environment/demo/deploy.tf

terraform init
terraform plan
terraform apply

# KUBESPRAY

Install Kubernetes cluster containing 2 Masters, 3 etcd, 3 nodes cluster  using kubespray

Git clone https://github.com/kubernetes-sigs/kubespray.git
sudo pip install -r requirements.txt
https://github.com/kubernetes-sigs/kubespray
declare -a IPS=(34.242.21.35  54.171.219.9 34.244.54.89) . Provide Public IP's of AWS cluster

CONFIG_FILE=inventory/mycluster/hosts.yml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
# Review and change parameters under inventory/mycluster/group_vars
cat inventory/mycluster/group_vars/all/all.yml
cat inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml

ansible-playbook -i inventory/mycluster/hosts.yml --become --become-user=root cluster.yml --flush-cache

ssh into 1 of the nodes
sudo su -

kubectl get nodes

# Create a CI/CD pipeline using Jenkins (or a CI tool of your choice) outside Kubernetes cluster (not as a pod inside Kubernetes cluster).

Spawn Jenkins server on one of the k8 masters

ssh in K8-master node1
Installed jenkins on server using a script.
Vi jenkins.sh
./jenkins.sh

# Create a development namespace.

From Workstation
kubectl create namespace development
kubectl get namespace


# Deploy guest-book application (or any other application which you think is more suitable to showcase your ability, kindly justify why you have chosen a different application) in the development namespace.

Ssh one of kubernetes nodes if workstation is not setup with kubectl cli

https://kubernetes.io/docs/tutorials/stateless-application/guestbook/

Start up a Redis master.
Start up Redis slaves.
Start up the guestbook frontend.
Expose and view the Frontend Service.

Start Redis master
Cd k8-terraform-application/guestbook-application
Kubectl apply -f redis-master-deployment.yaml

kubectl get deployment -n development
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
redis-master   1/1     1            1           15s

Create Redis master service
     Kubectl apply -f redis-master-service.yaml

kubectl get service -n development
NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
redis-master   ClusterIP   10.233.9.140   <none>        6379/TCP   51s

Start up Redis slaves.

Edit file with namespace
kubectl apply -f redis-slave-deployment.yaml

kubectl  get deployment -n development
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
redis-master   1/1     1            1           13m
redis-slave    2/2     2            2           34s


kubectl get pods -n development
NAME                           READY   STATUS    RESTARTS   AGE
redis-master-596696dd4-4zkhb   1/1     Running   0          14m
redis-slave-6bb9896d48-f5gvp   1/1     Running   0          65s
redis-slave-6bb9896d48-nj5n8   1/1     Running   0          65s

Redis slave service
kubectl  apply -f redis-slave-service.yaml
service/redis-slave created


kubectl get service -n development
NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
redis-master   ClusterIP   10.233.9.140   <none>        6379/TCP   10m
redis-slave    ClusterIP   10.233.55.11   <none>        6379/TCP   38s

Deploy Frontend app

kubectl apply -f guestbook-frontend-deployment.yaml
deployment.apps/frontend created

kubectl get pods -l app=guestbook -l tier=frontend -n development
NAME                        READY   STATUS    RESTARTS   AGE
frontend-69859f6796-k7mtg   1/1     Running   0          51s
frontend-69859f6796-rfgzn   1/1     Running   0          51s
frontend-69859f6796-t472d   1/1     Running   0          51s


Deploy frontend service type: Node Port
kubectl apply -f frontend-service.yaml

service/frontend created
root@node2:/home/ubuntu/application# kubectl  get service -n development
NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
frontend       NodePort    10.233.8.91    <none>        80:32720/TCP   30s
redis-master   ClusterIP   10.233.9.140   <none>        6379/TCP       22m
      redis-slave    ClusterIP   10.233.55.11   <none>        6379/TCP       12m


curl -I http://10.0.5.212:32720
HTTP/1.1 200 OK
Date: Wed, 03 Jul 2019 08:47:08 GMT
Server: Apache/2.4.10 (Debian) PHP/5.6.20
Last-Modified: Wed, 09 Sep 2015 18:35:04 GMT
ETag: "399-51f54bdb4a600"
Accept-Ranges: bytes
Content-Length: 921
Vary: Accept-Encoding
Content-Type: text/html

# Install and configure Helm in Kubernetes

Cd  helm
./helm_install.sh
This installs helm on cluster


# Use Helm to deploy the application on Kubernetes Cluster from CI server.

Create a monitoring namespace in the cluster
Kubectl create namespace monitoring


# Setup Prometheus (in monitoring namespace) for gathering host/container metrics along with health check status of the application. 

helm repo update
helm install stable/prometheus \
   --namespace monitoring \
   --name prometheus


To delete prometheus
helm del —-purge prometheus

helm install --name prometheus-new --namespace monitoring stable/prometheus --values values-prometheus.yaml

Get the Prometheus server URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace monitoring port-forward $POD_NAME 9090



Create a dashboard using Grafana to help visualize the Node/Container/API Server etc. metrices from Prometheus server. Optionally create a custom dashboard on Grafana

# GRAFANA

Git clone https://github.com/helm/charts.git

cd helm/charts/grafana/

helm install stable/grafana --namespace monitoring -n grafana --values values-grafana.yaml


1. Get your 'admin' user password by running:

   kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
u13YsgaH64JWDe0rx8bBAyfAdEB99ODVK9YNhQL1

2. The Grafana server can be accessed via port 80 on the following DNS name from within your cluster:

   grafana.monitoring.svc.cluster.local

   Get the Grafana URL to visit by running these commands in the same shell:

     export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=grafana,release=grafana" -o jsonpath="{.items[0].metadata.name}")
   nohup  kubectl --namespace monitoring port-forward $POD_NAME 3000 &

3. Login with the password from step 1 and the username: admin
#################################################################################
######   WARNING: Persistence is disabled!!! You will lose your data when   #####
######            the Grafana pod is terminated.                            #####
#################################################################################

http://34.252.206.133:30966/?orgId=1


Setup Node Metrics

Node_filesystem_avail_bytes → filesystem space available
rate(node_network_receive_bytes_total[1m]) → The average network traffic received, per second, over the last minute (in bytes)

For container metrics
 https://prometheus.io/docs/guides/cadvisor/
rate(container_network_transmit_bytes_total[1m])

# Setup log analysis using Elasticsearch, Fluentd (or Filebeat), Kibana.

cd elasticsearch-fluentd-kibana/elasticsearch
./resource_creation.sh

nohup kubectl port-forward es-cluster-0 9200:9200 --namespace=log&
curl http://localhost:9200/_cluster/state?pretty

# Creating the Kibana Deployment and Service

cd kibana-fluentd
kubectl create -f kibana.yaml
Nohup kubectl port-forward kibana-6c9fb4b5b7-plbg2 5601:5601 --namespace=log&

http://34.252.206.133:30677/app/kibana#/home?_g=()

# Deploy Fluentd Daemon set

kubectl create -f fluentd.yaml

# Demonstrate Blue/Green and Canary deployment for the application (For e.g. Change the background color or font in the new version etc.,)

This can be either done with help of spinnaker or Istio.
When a new version of application is launched. Make few users to point to new version of application using Loadbalancer on specific port.

Once the new version is well tested, move all old version to the latest version. This prevents application downtime.

