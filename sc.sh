#!/bin/sh
yum install epel-release -y
rpm -ivh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm
yum update -y
yum install puppet -y
source /root/.bashrc
source /root/.bash_profile
cat >> /etc/hosts <<EOF
192.168.33.10 client.server.com
192.168.33.27 zabbix.server.com
EOF

