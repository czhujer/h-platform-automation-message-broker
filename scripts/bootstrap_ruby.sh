#!/bin/bash

yum clean all -q

yum install which virt-what yum-utils epel-release deltarpm -y -q

#for vagrant/facter
yum install bind-utils net-tools -y -q

yum update -y -q

dnf module -y reset ruby
dnf module -y enable ruby:2.6
dnf module -y install ruby:2.6

yum -q -y install gcc-c++ patch readline-devel zlib-devel libxml2-devel libyaml-devel libxslt-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison git

yum install make ruby-devel redhat-rpm-config -y

dnf install --enablerepo=PowerTools augeas augeas-devel -y

#echo 'source /opt/rh/rh-ruby27/enable' >> /root/.bashrc
#
#echo '' >> /root/.bashrc;
#echo 'unset GEM_HOME' >> /root/.bashrc;
#echo 'unset GEM_PATH' >> /root/.bashrc;
