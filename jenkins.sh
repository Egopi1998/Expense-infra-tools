#!/bin/bash
curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install fontconfig java-17-openjdk jenkins -y
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# we need below configuration in jankins agent, we are using master as agent so installing on master only

yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
yum install zip -y
# # Exit immediately if a command exits with a non-zero status
# set -e

# # Update package lists
# echo "Updating package lists..."
# sudo yum update -y > dev/null

# # Install Nginx from Amazon Linux Extras
# echo "Installing Nginx..."
# sudo amazon-linux-extras enable nginx1 > dev/null
# sudo yum install -y nginx > dev/null



# # Start Nginx service
# echo "Starting Nginx service..."
# sudo systemctl start nginx 

# # Enable Nginx to start on boot
# echo "Enabling Nginx to start on boot..."
# sudo systemctl enable nginx 

# sudo rm -rf /usr/share/nginx/html/index.html

# echo "<h1>Hello from Nginx on EC2! 3 </h1>" | sudo tee /usr/share/nginx/html/index.html > /dev/null
# # Confirm Nginx is running
# echo "Nginx installation and setup complete."

