# my-project
## Continuously integrating and continuously deploying a containerized web application in EKS
## Aim
My aim of this project was using aws services like EC2 and EKS create some virtual servers,Kubernetes cluster and then setup a jenkin automation job for 
continuously integrate the changes made in application code and deploy it on EKS cluster as a containerized web application.
And the main aim is to integrate all the tools i studied with this CI/CD project like GIT & GITHUB,MAVEN,JENKINS,ANSIBLE,TERRAFORM,DOCKER,KUBERNETES(EKS).

### Description
There are 4 servers that are jenkinserver,ansibleserver,terraformserver and kubernetes server.when a code pushed to github,jenkinserver will pull the code and build the code to generate artifact(maven is also installed in jenkin server).After generating artifact and succesfully storing it,Terraform server will create an instance called "dockerserver" in the same region.After this docker server creation,Ansibleserver will configure the dockerserver by install some dependencies,docker etc.and will copy and paste artifacts,dockerfile also,and execute commands to build an docker image inside docker server and also push the created image to dockerhub(Note:-On each docker image building,the jenkins build number will specify as version of the docker image).After this,the kubernetes server will execute the deployment file to pull the latest image pushed on the dockerhub and will containerize it and then the service file will execute for exposing the containerized web application.

### Let's Start
First create 4 Amazon linux Instances in aws on same region and name the servers as : -

1,Jenkinserver
2,Ansibleserver
3,Terraformserver
4,kubernetesserver

### Let's goto Jenkinserver
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
### Goto Terraform server
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
### Goto Ansible server
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

### Goto Kubernetes server
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

## Let's build the jenkin job

Firstly install "PUBLISH OVER SSH PLUGIN" in jenkins and after installation add the "jenkinserver,ansibleserver,terraformserver & kubernetes server" in "manage jenkins" -> "Configure system" -> "publish over ssh"
Note :- put the users as the sudo users we created in each server and put remote directory as their path to home directory.eg:- /home/jenkiserver

Then goto "manage jenkins" -> "global tool configuration" -> select "git" -> "Path to Git executable column" -> /usr/bin/git

Then select "maven" -> "maven installation" -> "MAVEN_HOME" -> enter "/opt/maven/apache-maven-3.8.7"

Then apply -> save

### Then, 
```
select "New item" -> "Freestyle project" -> Enter name for the project -> "OK"
```
## Fresstyle Project
```
In "Description" column -> Enter "Description :- This is my own project which includeds git,github,maven,jenkins,ansible,terraform,docker and kubernetes"
```
```
Then,In "source code mangement" ->  select "git" -> "Add repository url and credentials" -> "build to manage" -> Enter "*/master"
```
```
Then in, "build triggers" -> select "POLL SCM" and enter "* * * * *".(This cron expression check for any change in github repository and get triggered,you can also use GitHub hook trigger for GITScm polling and in that case you have to configure in github under webhook section with jenkins public ip address
```
```
Then in, "Build Environment" -> select "Delete workspace before build starts"
```
```
Then in, "Build Steps" -> select "Invoke top-level Maven targets" -> select the maven version -> Goals -> enter "clean install"(it is maven command to build the code).
```
Then again, select "Send files or execute commands over SSH" in "Build steps"-> "select the terraform server already configure in publish over ssh" and in exec command colum enter the below commands :- 
```
cd mycreation
sudo terraform init
sudo terraform plan 
sudo terraform apply -auto-approve
sudo sleep 10
```

Then again, select "Send files or execute commands over SSH" in "Build steps"-> "select the ansible server already configure in publish over ssh" and in exec command colum enter the below commands :- 
```
sudo sh /home/ansadmin/deletescript.sh
```

Then again, select "Send files or execute commands over SSH" in "Build steps"-> "select the ansible server already configure in publish over ssh" -> "sourcefile"    -> enter  "**/*.war" -> "remote directory" -> enter "warfile" -> In "Exec command" enter the below commands :- 
```
sudo ansible all --list
sudo ansible -m ping all
sudo ansible-playbook /home/ansadmin/instanceconfigure/ansibleplaybook.yml -e "jenkins_build_number=$BUILD_NUMBER"
```
Then again, select "Send files or execute commands over SSH" in "Build steps"-> "select the kubernetes server already configure in publish over ssh" and in exec command colum enter the below commands :- 
```
cd /home/kubeadmin/onlinebookstore
kubectl delete service myapp --ignore-not-found=true
kubectl delete deployment myapp --ignore-not-found=true
sudo sed -i "s/tomcatcustom./tomcatcustom.$BUILD_NUMBER/g" deployment.yml
kubectl apply -f deployment.yml
kubectl apply -f service.yml
sudo sed -i "s/tomcatcustom.$BUILD_NUMBER/tomcatcustom./g" deployment.yml
```
Then click "Apply" -> "save" 

Then click on "BUILD NOW"
Now you can see the above steps jenkins executing in the console output.
Note:- To verify the continuous integration and continuous,just made a change in the source code and push to the GitHub.

That's all,the Project is Completed.




                        





