# my-project
Continuously integrating and continuously deploying a containerized web application in EKS
# Aim
My aim of this project was using aws services like EC2 and EKS create some virtual servers,Kubernetes cluster and then setup a jenkin automation job for 
continuously integrate the changes made in application code and deploy it on EKS cluster as a containerized web application.
And the main aim is to integrate all the tools i studied with this CI/CD project like GIT & GITHUB,MAVEN,JENKINS,ANSIBLE,TERRAFORM,DOCKER,KUBERNETES(EKS).

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
## Goto 
