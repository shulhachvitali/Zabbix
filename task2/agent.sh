#!/bin/sh
yum install epel-release -y
rpm -ivh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm
yum update -y
yum install httpd vim mlocate net-utils -y
cat >> /etc/hosts <<EOF
192.168.33.26 abbixagent.server.com
192.168.33.27 zabbix.server.com
EOF
yum install zabbix zabbix-agent -y
yum clean all
chkconfig --level 345 httpd on
chkconfig --level 345 zabbix-agent on
