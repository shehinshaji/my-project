terraform {
  required_providers {
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = ">= 2.2"
    }
  }
}


provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "instance_creation" {
  ami           = "ami-0f1a5f5ada0e7da53"
  instance_type = "t2.micro"
  key_name = "keypair"
  vpc_security_group_ids = ["sg-0dd7359e822b40390"]
  subnet_id = "subnet-9693c9ef"
  tags = {
    Name = "dockerserver"
  }
  user_data = <<EOF
              #!/bin/bash
              echo "${file("/home/tefadmin/id_rsa.pub")}" > /root/.ssh/authorized_keys 
              EOF

}



