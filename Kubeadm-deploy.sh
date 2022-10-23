#!/bin/bash
systemctl disable firewalld
systemctl stop firewalld
sed -i 's/SELINUX=enforcing/SELINUX=disabled/gi' /etc/sysconfig/selinux
swapoff -a
echo net.bridge.bridge-nf-call-iptables = 1 >> /etc/sysctl.conf
sysctl -p
echo 1 > /proc/sys/net/ipv4/ip_forward
yum install yum-utils -y
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=0
EOF
yum install docker -y
systemctl start docker
systemctl enable docker
yum install -y kubelet kubeadm kubectl
systemctl daemon-reload
systemctl start kubelet
systemctl enable kubelet
rm -f /etc/containerd/config.toml
systemctl restart containerd
kubeadm init --ignore-preflight-errors=NumCPU
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl create -f calico.yaml
