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
