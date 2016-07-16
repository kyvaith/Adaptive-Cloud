stage { 'first': before => Stage['main'] }
class { 'puppetlabs_yum': stage => first }
class { 'epel': stage => first }

create_resources(package, hiera('gemlist', {}))
create_resources(package, hiera('rpmlist', {}))
class { '::ntp': }
service { "firewalld":
  ensure => "stopped",
  enable => false,
}

node 'hosting1.example.com' {
  include sysctl::base
  include mysql::server
  include docker
  include docker_compose
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
  exec { 'clone_docker_repo':
    command => '/bin/git clone -b beta-0.1 https://github.com/kyvaith/Adaptive-Cloud-Dockerfiles /tmp/Adaptive-Cloud-Dockerfiles',
    onlyif  =>  [
      '/usr/bin/test -e /bin/git',
      '/usr/bin/test ! -d /tmp/Adaptive-Cloud-Dockerfiles'
    ]
  }
  exec { 'run_containers':
    command => '/usr/local/bin/docker-compose -f /tmp/Adaptive-Cloud-Dockerfiles/docker-composer/nginx-memcached/docker-compose.yml up -d',
    timeout => 1800,
    onlyif  =>  [
      '/usr/bin/test -d /tmp/Adaptive-Cloud-Dockerfiles',
      '/usr/bin/test -e /usr/local/bin/docker-compose'
    ]
  }
}

node 'buildsrv.example.com' {
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
