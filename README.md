# my-project
Continuously integrating and continuously deploying a containerized web application in EKS
## Aim
My aim of this project was using aws services like EC2 and EKS create some virtual servers,Kubernetes cluster and then setup a jenkin automation job for 
continuously integrate the changes made in application code and deploy it on EKS cluster as a containerized web application.
And the main aim is to integrate all the tools i studied with this CI/CD project like GIT & GITHUB,MAVEN,JENKINS,ANSIBLE,TERRAFORM,DOCKER,KUBERNETES(EKS).

## Description
There are 4 servers that are jenkinserver,ansibleserver,terraformserver and kubernetes server.when a code pushed to github,jenkinserver will pull the code and build the code to generate artifact(maven is also installed in jenkin server).After generating artifact and succesfully storing it,Terraform server will create an instance called "dockerserver" in the same region.After this docker server creation,Ansibleserver will configure the dockerserver by install some dependencies,docker etc.and will copy and paste artifacts,dockerfile also,and execute commands to build an docker image inside docker server and also push the created image to dockerhub(Note:-On each docker image building,the jenkins build number will specify as version of the docker image).After this,the kubernetes server will execute the deployment file to pull the latest image pushed on the dockerhub and will containerize it and then the service file will execute for exposing the containerized web application.

## Let's Start
First create 4 Amazon linux Instances in aws on same region and name the servers as : -

1,Jenkinserver
2,Ansibleserver
3,Terraformserver
4,kubernetesserver

## Let's goto Jenkinserver
In jenkin server install : -
.GIT
.MAVEN
.JENKINS
Then create an new user "jenkinsadmin" and set password and give root user privileges:-
```
useradd jenkinsadmin
passwd jenkinsadmin
passwd root
visudo
jenkinsadmin ALL=(ALL:ALL) NOPASSWD: ALL
:wq!
vi /etc/ssh/sshd_config
PasswordAuthentication yes
systemctl restart sshd
```
## Goto Terraform server
In terraformserver install and setup terraform and then create a user "tefadmin" and set password and give root user privileges as done in jenkinserver.
Then just create a file  "id_rsa.pub" and create a directory "dockerserver".
```
touch /home/tefadmin/id_rsa.pub
mkdir /home/tefadmin/dockerserver
```
Then in dockerserver,create an "main.tf" file and paste the contents in the attached main.tf file in this repository.
```
cd /home/tefadmin/dockerserver
vi main.tf
:wq!
```
## Goto Ansible server
In Ansible server install and setup ansible and also an dynamic inventory.Then create a user "ansadmin" and set password and give root user privileges as done previously.
Then copy and paste the attached deletescript.sh on the path /home/ansadmin and also create an directory "dockerconfigure" and inside dockerconfigure create another directory "warfile".
```
mkdir /home/ansadmin/dockerconfigure
mkdir /home/ansadmin/dockerconfigure/warfile
```
Then copy and paste the attached "dockerfile & ansibleplaybook.yml" in /home/ansadmin/dockerconfigure.
Then generate private key and public key for root user: -
```
ssh-keygen
```
Then copy the "id_rsa.pub" to terraform server's /home/tefadmin/id_rsa.pub

## Goto Kubernetes server
In kubernetes server create a user "kubeadmin" and set password and give root user privileges as done previously.Then install and configure kubectl,eksctl,awscli.
Then create an IAM role in aws for creating,accessing and managing EKS cluster and attach the role to the Kubernetes server through aws(Note: Check eksctl documentaiton for Minimum IAM policies).
Then create the EKS cluster : -
```
eksctl create cluster --name demo-cluster --region ap-south-1 --node-type t2.small
```
Note: name,region and type change as your wish
Then create an directory manifest in /home/kubeadmin
```
mkdir /home/kubeadmin/manifest
```
Then inside manifest copy and paste the attached deployment and service yaml files.
