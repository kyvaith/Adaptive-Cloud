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
  create_resources(kmod::load, hiera('kmod_load', {}))
  include sysctl::base
  create_resources(package, hiera('rpms', {}))
  create_resources(yumrepo, hiera_hash('yumrepos'), {})
  class { '::mysql::server': }
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
