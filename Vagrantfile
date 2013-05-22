# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

    config.vm.synced_folder 'salt/', '/srv/salt/'
    config.vm.synced_folder 'pillar/', '/srv/pillar/'
    config.vm.hostname = 'agiledata'
    config.vm.box = 'precise64'
    config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

    config.vm.provider :virtualbox do |vb|
        vb.customize ['modifyvm', :id, '--ioapic', 'on']
        vb.customize ['modifyvm', :id, '--cpus', 2]
        vb.customize ['modifyvm', :id, '--memory', 1024]
    end

    config.vm.provision :salt do |salt|
        salt.minion_config = 'minion.conf'
        salt.verbose = true
        salt.run_highstate = true
    end

end
