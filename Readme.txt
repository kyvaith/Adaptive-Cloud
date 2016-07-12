Software:
- Vagrant: https://www.vagrantup.com/downloads.html
- VirtualBox: https://www.virtualbox.org/wiki/Downloads
- VirtualBox Extension Pack: https://www.virtualbox.org/wiki/Downloads
- Git: https://git-scm.com/downloads

Next steps after software installation:
1. Clone github repository:
git clone https://github.com/kyvaith/Adaptive-Cloud
2. Go to repo directory:
cd ./Adaptive-Cloud
3. Checkout vagrant virtual machines definition:
vagrant status
4. Run one of virtual machine:
vagrant up <MACHINE_NAME>
5. Rerun virtual machine provisioning if needed:
vagrant provision <MACHINE_NAME>
6. Login in to the virtual machine shell:
vagrant ssh <MACHINE_NAME>
7. Destroy virtual machine:
vagrant destroy <MACHINE_NAME>

Hardware parameter modification of virtual machine:
- Edit file: Vagrantfile
- Make changes in line: vb.customize [...........]

Run puppet inside virtual machine:
1. Go to directory with puppet files:
cd /vagrant
2. Run command - puppet in test mode:
puppet apply --hiera_config=./hiera.yaml --modulepath=./modules ./manifests/site.pp -v --test
3. Run command - apply puppet configuration in verbose mode:
puppet apply --hiera_config=./hiera.yaml --modulepath=./modules ./manifests/site.pp -v

How to test hiera:
hiera -d -c ./hiera.yaml rpmlist enviroment=productio
-d - debug
-c - config file
hiera -d -c<HIERA_CONF_FILE> <PUPPET_CLASS> <environment>

RPM repo with extra rpms(memcached, nginx):
http://download.opensuse.org/repositories/home:/kyvaith:/Adaptive-Cloud/CentOS_7/


External links:
HTTPS:
letsencrypt https://community.centminmod.com/threads/welcome-to-acmetool-sh-new-letsencrypt-addon-for-centmin-mod-lemp-stacks.7476/
https://github.com/hlandau/acme

WordPress CLI:
https://centminmod.com/addons.html#wpcli
https://wp-cli.org
DigitalOcean+WP_CLI: https://www.digitalocean.com/community/tutorials/how-to-use-wp-cli-to-manage-your-wordpress-site-from-the-command-line
