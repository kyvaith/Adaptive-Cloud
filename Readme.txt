Tools:
- Vagrant: https://www.vagrantup.com/downloads.html
- VirtualBox: https://www.virtualbox.org/wiki/Downloads
- VirtualBox Extension Pack: https://www.virtualbox.org/wiki/Downloads
- Git: https://git-scm.com/downloads

Po zainstalowaniu wyżej wymienionych pakietów należy:
1. Pobrać repo:
git clone https://github.com/oisis/packer-centos7
2. Wejść do pobranego katalogu:
cd ./costam
3. sprawdzić dostępne maszyny wirtualne w Vagrancie:
vagrant status
4. Uruchomić dowolną maszynę polecenniem:
vagrant up <NAZWA_MASZYNY>
5. Ponowne uruchomienie provisioningu:
vagrant provision <NAZWA_MASZYNY>
6. Zalogować się do shell uruchomionej maszyny:
vagrant ssh <NAZWA_MASZYNY>
7. Po skończonej pracy usunąć maszynę:
vagrant destroy <NAZWA_MASZYNY>

Modyfikacja zasobow maszyny wirtualnej:
- Plik Vagrantfile
- Edytujemy linię: vb.customize [...........]

Uruchomienie puppeta z poziomu OS:
1. Wchodzimy do katalogu z plikami puppeta:
cd /vagrant
2. Uruchamiamy komendę - puppet w trybie testu:
puppet apply --hiera_config=./hiera.yaml --modulepath=./modules ./manifests/site.pp -v --test
3. Uruchamiamy komendę - puppet w trybie normalnym + verbose:
puppet apply --hiera_config=./hiera.yaml --modulepath=./modules ./manifests/site.pp -v


RPM repo:
http://download.opensuse.org/repositories/home:/kyvaith:/Adaptive-Cloud/CentOS_7/


Testowanie hiery:
hiera -d -c ./hiera.yaml rpmlist enviroment=productio
-d - debug
-c - config file

hiera -d -c<HIERA_CONF_FILE> <PUPPET_CLASS> <environment>

HTTPS:
letsencrypt https://community.centminmod.com/threads/welcome-to-acmetool-sh-new-letsencrypt-addon-for-centmin-mod-lemp-stacks.7476/
https://github.com/hlandau/acme

WordPress CLI:
https://centminmod.com/addons.html#wpcli
https://wp-cli.org
DigitalOcean+WP_CLI: https://www.digitalocean.com/community/tutorials/how-to-use-wp-cli-to-manage-your-wordpress-site-from-the-command-line
