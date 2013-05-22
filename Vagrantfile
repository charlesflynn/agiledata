# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

nodecfg = YAML::load_file('vagrantcfg.yml')
nodecfg['nodes'].each do |node|
    node.merge!(nodecfg['default']) { |key, nval, tval | nval }
    node['box_url'] = nodecfg['boxes'][node['box']]
    node['fqdn'] = node['name'] + '.' + node['domain']
end

Vagrant.configure("2") do |config|

    nodecfg['nodes'].each do |node|
        config.vm.define node['name'] do |node_config|
            node_config.vm.synced_folder "salt/", "/srv/salt/"
            node_config.vm.synced_folder "pillar/", "/srv/pillar/"
            node_config.vm.hostname = node['name']
            node_config.vm.box = node['box']
            node_config.vm.box_url = node['box_url']

            node_config.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--ioapic", "on"]
                vb.customize ["modifyvm", :id, "--cpus", node['cpus']]
                vb.customize ["modifyvm", :id, "--memory", node['memory']]
                vb.customize ["modifyvm", :id, "--name", node['name']]
            end

            node_config.vm.provision :salt do |salt|
                salt.minion_config = "minion.conf"
                salt.verbose = true
                salt.run_highstate = true
            end

        end
    end
end
