# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
config.vm.provision "shell", path: "sc.sh" 
config.vm.define "zabbix" do |zabbix|
    zabbix.vm.box = "centos/6"
    zabbix.vm.hostname = "zabbix.server.com"
    zabbix.vm.network "private_network", ip: "192.168.33.27"
    zabbix.vm.provider "virtualbox" do |cfg|
      cfg.name = "zabbix-cfg"
      cfg.cpus = 1
      cfg.memory = 3128
   end
    
  end  
config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules" 
end
end

