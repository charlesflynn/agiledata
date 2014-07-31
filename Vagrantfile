# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "salt/", "/srv/salt/"
  config.vm.synced_folder "pillar/", "/srv/pillar/"

  config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.provision :salt do |salt|
      salt.minion_config = "minion.conf"
      salt.run_highstate = true
  end

end
