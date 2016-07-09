stage { 'first': before => Stage['main'] }
class { 'puppetlabs_yum': stage => first }
class { 'epel': stage => first }

create_resources(package, hiera('rpmlist', {}))

service { "firewalld":
  ensure => "stopped",
  enable => false,
}

class { '::ntp': }

node 'hosting1.tomekw.pl' {
  kmod::load { 'nf_conntrack_ipv4': }
  kmod::load { 'nf_defrag_ipv4': }
  kmod::load { 'xt_conntrack': }
  kmod::load { 'nf_conntrack_ftp': }
  kmod::load { 'nf_conntrack_ipv6': }
  kmod::load { 'nf_conntrack': }
  include sysctl::base
  create_resources(package, hiera('rpms', {}))
  yumrepo { 'percona':
    descr    => 'CentOS $releasever - Percona',
    baseurl  => 'http://repo.percona.com/centos/$releasever/os/$basearch/',
    gpgkey   => 'http://www.percona.com/downloads/percona-release/RPM-GPG-KEY-percona',
    enabled  => '0',
    gpgcheck => '1',
  }
  yumrepo { 'mariadb':
    descr    => 'MariaDB',
    baseurl  => 'http://yum.mariadb.org/10.1/centos7-amd64',
    gpgkey   => 'https://yum.mariadb.org/RPM-GPG-KEY-MariaDB',
    gpgcheck => '1',
    enabled  => '1',
    exclude  => 'MariaDB-Galera-server',
  }

  include ::mysql::server

  class { 'docker': }
}

node 'buildsrv.tomekw.pl' {
  yum::group { 'Development Tools':
    ensure => present,
  }
  create_resources(package, hiera('rpm_list', {}))
  exec { 'install_remi_yum_repo':
    command => '/usr/bin/rpm -ihv --replacepkgs http://rpms.famillecollet.com/enterprise/remi-release-7.rpm',
  }
  class { 'docker': }
  class { 'jenkins': }
  class { 'jenkins::master': }
  create_resources(jenkins::plugin, hiera('jenkins_plugins', {}))
}
