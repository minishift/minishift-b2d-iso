#!/bin/bash

# Output command before executing
set -x

# Exit on error
set -e

# Source environment variables of the jenkins slave
# that might interest this worker.
if [ -e "jenkins-env" ]; then
  cat jenkins-env \
    | grep -E "(JENKINS_URL|GIT_BRANCH|GIT_COMMIT|BUILD_NUMBER|ghprbSourceBranch|ghprbActualCommit|BUILD_URL|ghprbPullId)=" \
    | sed 's/^/export /g' \
    > ~/.jenkins-env
  source ~/.jenkins-env
fi

# We need to disable selinux for now, XXX
/usr/sbin/setenforce 0

# Get all the deps in
yum -y install \
  make \
  git \
  epel-release \
  livecd-tools \
  curl

# Install Docker (https://docs.docker.com/engine/installation/linux/centos/#/install-with-the-script)
curl -fsSL https://get.docker.com/ | sh
systemctl enable docker.service
systemctl start docker

# Install Libvirt
yum -y install kvm qemu-kvm libvirt
systemctl start libvirtd

# Install Avocado
curl https://repos-avocadoproject.rhcloud.com/static/avocado-el.repo -o /etc/yum.repos.d/avocado.repo
yum install -y avocado

# Prepare ISO for testing
make iso

# Let's test
make test
