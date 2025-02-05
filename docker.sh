#!/bin/bash

# docker
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

#kubectl and eksctl
KUBECTL_VALIDATION=$(kubectl version --client)
if [ ! -f /usr/local/bin/kubectl ]; then
    curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    chmod +x kubectl
    mkdir -p ~/.local/bin
    mv ./kubectl ~/.local/bin/kubectl
elif [ -z "$KUBECTL_VALIDATION" ]; then 
# -z is used to check if the string is empty
# if the string is empty then kubectl is not installed
    echo "kubectl installed but not working"
else 
    echo "kubectl is already installed"
fi
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
if [ ! -f /usr/local/bin/eksctl ]; then
    echo "installing eksctl"
    curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

    # (Optional) Verify checksum
    curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

    tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

    sudo mv /tmp/eksctl /usr/local/bin
else
    echo "eksctl is already installed"
    exit 0
fi

