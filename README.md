# my-project
Continuously integrating and continuously deploying a containerized web application in EKS
# Aim
My aim of this project was using aws services like EC2 and EKS create some virtual servers,Kubernetes cluster and then setup a jenkin automation job for 
continuously integrate the changes made in application code and deploy it on EKS cluster as a containerized web application.
And the main aim is to integrate all the tools i studied with this CI/CD project like GIT & GITHUB,MAVEN,JENKINS,ANSIBLE,TERRAFORM,DOCKER,KUBERNETES(EKS).

# Let's Start
First create 4 Amazon linux Instances in aws on same region and name the servers as : -

1,Jenkinserver
2,Ansibleserver
3,Terraformserver
4,kubernetesserver

# Let's take Jenkinserver
In jenkin server install git,maven and jenkins.
GIT INSTALLATION:-
sudo yum update -y
sudo yum install git -y
git version
