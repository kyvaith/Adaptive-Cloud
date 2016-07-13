stage { 'first': before => Stage['main'] }
class { 'puppetlabs_yum': stage => first }
class { 'epel': stage => first }

create_resources(package, hiera('gemlist', {}))
create_resources(package, hiera('rpmlist', {}))

service { "firewalld":
  ensure => "stopped",
  enable => false,
}

class { '::ntp': }

node 'hosting1.tomekw.pl' {
  include sysctl::base
  include wordpress
  include mysql::server
  include docker
  include docker_compose
  include wordpress
  create_resources('kmod::load', hiera('kmod_load', {}))
  create_resources(package, hiera('rpms', {}))
  create_resources(yumrepo, hiera_hash('yumrepos'), {})
  create_resources('mysql::db', hiera_hash('mysqldb'), {})
  create_resources('wordpress::instance', hiera_hash('wpinstance'), {})
  Class['::mysql::server'] ->
  Class['::docker'] ->
  Class['::docker_compose']
  exec { 'mkdirs_wordpress':
    command => '/bin/mkdir -p /home/hostings/example{1,2}.com/{html,extra.conf.d}',
  }
  exec { 'chown_dirs':
    command => '/bin/chown -R nobody:nobody /home/hostings',
    onlyif  =>  [ '/usr/bin/test -d /home/hostings/' ]
  }
}

node 'buildsrv.tomekw.pl' {
  yum::group { 'Development Tools':
    ensure => present,
  }
  create_resources(package, hiera('rpm_list', {}))
  exec { 'install_remi_yum_repo':
    command => '/usr/bin/rpm -ihv --replacepkgs http://rpms.famillecollet.com/enterprise/remi-release-7.rpm',
  }
  class { '::docker': }
  class { '::docker_compose': }
  class { '::jenkins': }
  class { '::jenkins::master': }
  create_resources(jenkins::plugin, hiera('jenkins_plugins', {}))
}
