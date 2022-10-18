#!/bin/bash
amazon-linux-extras install java-openjdk11 -y
#yum -y install java-11-openjdk java-11-openjdk-devel
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y
systemctl enable jenkins
systemctl start jenkins
systemctl status jenkins
jenkinspasswd=`cat /var/lib/jenkins/secrets/initialAdminPassword`
jenkinsurl=`dig +short myip.opendns.com @resolver1.opendns.com`
echo "Your  Jenkins URL is $jenkinsurl:8080 and password is $jenkinspasswd"
