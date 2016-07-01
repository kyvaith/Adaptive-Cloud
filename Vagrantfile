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
192.168.0.2 hosting1.tomekw.pl
192.168.0.3 rpm.tomekw.pl
192.168.0.4 docker.tomekw.pl
EOF
SCRIPT

  config.vm.define "hosting1" do |config|
    config.vm.hostname = "hosting1.tomekw.pl"
    config.vm.provision "shell", inline: $fill_hosts
    config.vm.network :private_network,ip: "192.168.0.2"
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :forwarded_port, guest: 443, host: 8443
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

  config.vm.define "rpm" do |config|
    config.vm.hostname = "rpm.tomekw.pl"
    config.vm.provision "shell", inline: $fill_hosts
    config.vm.network :private_network,ip: "192.168.0.3"
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
      vb.customize ["modifyvm", :id, "--memory", "4096", "--cpus", 1, "--ioapic", "on", "--cpuexecutioncap", "50"]
    end
  end

  config.vm.define "docker" do |config|
    config.vm.hostname = "docker.tomekw.pl"
    config.vm.provision "shell", inline: $fill_hosts
    config.vm.network :private_network,ip: "192.168.0.4"
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
      vb.customize ["modifyvm", :id, "--memory", "4096", "--cpus", 1, "--ioapic", "on", "--cpuexecutioncap", "50"]
    end
  end

end
