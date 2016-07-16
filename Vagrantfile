# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box_check_update = false
    config.vm.box = "vStone/centos-7.x-puppet.3.x"
    config.vm.provider :virtualbox do |vb|
        vb.gui = false
    end

$fill_hosts = <<SCRIPT
cat >> /etc/hosts <<EOF
192.168.0.2 hosting1.example.com
192.168.0.3 buildsrv.example.com
EOF
SCRIPT

  config.vm.define "hosting1" do |config|
    config.vm.hostname = "hosting1.example.com"
    config.vm.provision "shell", inline: $fill_hosts
    config.vm.network :private_network,ip: "192.168.0.2"
    config.vm.network :forwarded_port, guest: 9000, host: 9000
    config.vm.network :forwarded_port, guest: 9001, host: 9001
    config.vm.network :forwarded_port, guest: 9002, host: 9002
    config.vm.network :forwarded_port, guest: 9003, host: 9003
    config.vm.network :forwarded_port, guest: 9004, host: 9004
    config.vm.network :forwarded_port, guest: 9005, host: 9005
    config.vm.network :forwarded_port, guest: 9006, host: 9006
    config.vm.network :forwarded_port, guest: 9007, host: 9007
    config.vm.network :forwarded_port, guest: 9008, host: 9008
    config.vm.network :forwarded_port, guest: 9009, host: 9009
    config.vm.network :forwarded_port, guest: 9010, host: 9010
    config.vm.network :forwarded_port, guest: 9443, host: 9443
    config.vm.network :forwarded_port, guest: 10443, host: 10443
    config.vm.provision :puppet do |puppet|
      puppet.module_path = 'modules'
      puppet.manifest_file = 'site.pp'
      puppet.working_directory = "/vagrant"
      puppet.hiera_config_path = "hiera.yaml"
#      puppet.options = '--verbose --debug'
      puppet.facter = {
        "fact_test" => "test123"
      }
    end
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", 1, "--ioapic", "on", "--cpuexecutioncap", "50"]
    end
  end

  config.vm.define "buildsrv" do |config|
    config.vm.hostname = "buildsrv.example.com"
    config.vm.provision "shell", inline: $fill_hosts
    config.vm.network :private_network,ip: "192.168.0.3"
    config.vm.network :forwarded_port, guest: 8080, host: 8080
    config.vm.network :forwarded_port, guest: 8001, host: 8001
    config.vm.network :forwarded_port, guest: 8002, host: 8002
    config.vm.network :forwarded_port, guest: 8003, host: 8003
    config.vm.network :forwarded_port, guest: 8004, host: 8004
    config.vm.network :forwarded_port, guest: 8005, host: 8005
    config.vm.provision :puppet do |puppet|
      puppet.module_path = 'modules'
      puppet.manifest_file = 'site.pp'
      puppet.working_directory = "/vagrant"
      puppet.hiera_config_path = "hiera.yaml"
      puppet.facter = {
        "fact_test" => "test123"
      }
    end
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", 1, "--ioapic", "on", "--cpuexecutioncap", "50"]
    end
  end
end
