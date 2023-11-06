#!/bin/bash
sudo yum update -y

sudo amazon-linux-extras install docker -y

sudo systemctl start docker

sudo systemctl enable docker

sudo usermod -a -G docker ec2-user

sudo chmod 666 /var/run/docker.sock

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions to the Docker Compose binary
sudo chmod +x /usr/local/bin/docker-compose

docker run -p 80:80 public.ecr.aws/awsandy/docker-2048:latest