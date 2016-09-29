### Zabbix lab task 1
Puppet + zabbix-server + zabbix-agent 

##The schema is:

1. During creating virtual machine vagrant starts two provision steps:

First - is to start [bash script](sc.sh), which installs epel repository, repository for zabbix (I could not activate it via puppet), updates yum, installs puppet and writes hosts addresses into hosts file.

Second step - provision by puppet. To start puppet inside vm vagrant uses initial ([default.pp](manifests/default.pp)) manifest, with starts puppet provision of VM.

Puppet module "Zabbix" contain scenario for set up of VM [server.pp](modules/zabbix/manifests/server.pp), t=started by [init.pp](modules/zabbix/manifests/init.pp). Resources for zabbix module are in the folder [Templates](modules/zabbix/templates/) 

2. After provision I turn off selinux, and got zabbix rite on the 80 port without prefix (due to virtual host in the config for httpd).
results are on the [screenshots](Source/)
