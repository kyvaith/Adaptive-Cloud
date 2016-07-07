stage { 'first': before => Stage['main'] }
class { 'puppetlabs_yum': stage => first }
class { 'epel': stage => first }

$enhancers = [ "mc", "zsh", "screen", "bind-utils", "htop", "telnet", "wget", "epel-release" ]
package { $enhancers: ensure => "installed" }
package { "chef": ensure => "purged", }

service { "firewalld":
  ensure => "stopped",
  enable => false,
}

class { '::ntp':
  servers => [ '0.pl.pool.ntp.org', '1.pl.pool.ntp.org' ],
}

node 'hosting1.tomekw.pl' {
  kmod::load { 'nf_conntrack_ipv4': }
  kmod::load { 'nf_defrag_ipv4': }
  kmod::load { 'xt_conntrack': }
  kmod::load { 'nf_conntrack_ftp': }
  kmod::load { 'nf_conntrack_ipv6': }
  kmod::load { 'nf_conntrack': }
  include sysctl::base
  $enhancers = [ "libevent", ]
  package { $enhancers: ensure => "installed" }
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
  $override_options = {
    'client' => {
      'socket' => '/var/lib/mysql/mysql.sock',
    },
    'mysqld' => {
      'local-infile'                  => '0',
      'pid-file'                      => '/tmp/mariadb.pid',
      'ignore_db_dirs'                => 'lost+found',
      'datadir'                       => '/var/lib/mysql',
      'socket'                        => '/var/lib/mysql/mysql.sock',
      'tmpdir'                        => '/tmp',
      'innodb'                        => 'ON',
      'back_log'                      => '75',
      'max_connections'               => '300',
      'key_buffer_size'               => '32M',
      'myisam_sort_buffer_size'       => '32M',
      'myisam_max_sort_file_size'     => '2048M',
      'join_buffer_size'              => '64K',
      'read_buffer_size'              => '64K',
      'sort_buffer_size'              => '128K',
      'table_definition_cache'        => '4096',
      'table_open_cache'              => '2048',
      'thread_cache_size'             => '64',
      'wait_timeout'                  => '1800',
      'connect_timeout'               => '10',
      'tmp_table_size'                => '32M',
      'max_heap_table_size'           => '32M',
      'max_allowed_packet'            => '32M',
      'max_seeks_for_key'             => '1000',
      'group_concat_max_len'          => '1024',
      'max_length_for_sort_data'      => '1024',
      'net_buffer_length'             => '16384',
      'max_connect_errors'            => '100000',
      'concurrent_insert'             => '2',
      'read_rnd_buffer_size'          => '256K',
      'bulk_insert_buffer_size'       => '8M',
      'query_cache_limit'             => '512K',
      'query_cache_size'              => '16M',
      'query_cache_type'              => '1',
      'query_cache_min_res_unit'      => '2K',
      'query_prealloc_size'           => '262144',
      'query_alloc_block_size'        => '65536',
      'transaction_alloc_block_size'  => '8192',
      'transaction_prealloc_size'     => '4096',
      'default-storage-engine'        => 'InnoDB',
      'log_warnings'                  => '1',
      'slow_query_log'                => '0',
      'long_query_time'               => '1',
      'slow_query_log_file'           => '/var/lib/mysql/slowq.log',
      'log-error'                     => '/var/log/mysqld.log',
      'innodb_large_prefix'           =>'1',
      'innodb_purge_threads'          =>'1',
      'innodb_file_format'            =>'Barracuda',
      'innodb_file_per_table'         =>'1',
      'innodb_open_files'             =>'1000',
      'innodb_data_file_path'         =>'ibdata1:10M:autoextend',
      'innodb_buffer_pool_size'       =>'48M',
      'innodb_log_files_in_group'     => '2',
      'innodb_log_file_size'          => '128M',
      'innodb_log_buffer_size'        => '8M',
      'innodb_flush_log_at_trx_commit' => '2',
      'innodb_lock_wait_timeout'      => '50',
      'innodb_flush_method'           => 'O_DIRECT',
      'innodb_support_xa'             => '1',
      'innodb_io_capacity'            => '100',
      'innodb_io_capacity_max'        => '2000',
      'innodb_read_io_threads'        => '2',
      'innodb_write_io_threads'       => '2',
    },
    'mariadb' => {
      'userstat'                    => '0',
      'key_cache_segments'          => '1',
      'aria_group_commit'           => 'none',
      'aria_group_commit_interval'  => '0',
      'aria_log_file_size'          => '32M',
      'aria_log_purge_type'         => 'immediate',
      'aria_pagecache_buffer_size'  => '8M',
      'aria_sort_buffer_size'       => '8M',
    },
    'mariadb-5.5' => {
      'innodb_file_format'              => 'Barracuda',
      'innodb_file_per_table'           => '1',
      'query_cache_strip_comments'      => '0',
      'innodb_read_ahead'               => 'linear',
      'innodb_adaptive_flushing_method' => 'estimate',
      'innodb_flush_neighbor_pages'     => '1',
      'innodb_stats_update_need_lock'   => '0',
      'innodb_log_block_size'           => '512',
      'log_slow_filter'                 => 'admin,filesort,filesort_on_disk,full_join,full_scan,query_cache,query_cache_miss,tmp_table,tmp_table_on_disk',
    },
    'mysqld_safe' => {
      'socket'            => '/var/lib/mysql/mysql.sock',
      'log-error'         => '/var/log/mysqld.log',
      'open-files-limit'  => '8192',
    },
    'mysqldump' => {
      'quick'               => '',
      'max_allowed_packet'  => '32M',
    },
    'myisamchk' => {
      'tmpdir'        => '/home/mysqltmp',
      'key_buffer'    => '32M',
      'sort_buffer'   => '16M',
      'read_buffer'   => '16M',
      'write_buffer'  => '16M',
    },
    'mysqlhotcopy' => {
      'interactive-timeout' => '',
    },
    'mariadb-10.0' => {
      'innodb_file_format'                => 'Barracuda',
      'innodb_file_per_table'             => '1',
      'innodb_buffer_pool_populate'       => '0',
      'performance_schema'                => 'OFF',
      'innodb_stats_on_metadata'          => 'OFF',
      'innodb_sort_buffer_size'           => '2M',
      'innodb_online_alter_log_max_size'  => '128M',
      'query_cache_strip_comments'        => '0',
      'log_slow_filter'                   => 'admin,filesort,filesort_on_disk,full_join,full_scan,query_cache,query_cache_miss,tmp_table,tmp_table_on_disk',

    },
    'mariadb-10.1' => {
      'innodb_file_format'                    => 'Barracuda',
      'innodb_file_per_table'                 => '1',
      'innodb_buffer_pool_populate'           => '0',
      'performance_schema'                    => 'OFF',
      'innodb_stats_on_metadata'              => 'OFF',
      'innodb_sort_buffer_size'               => '2M',
      'innodb_online_alter_log_max_size'      => '128M',
      'query_cache_strip_comments'            => '0',
      'log_slow_filter'                       => 'admin,filesort,filesort_on_disk,full_join,full_scan,query_cache,query_cache_miss,tmp_table,tmp_table_on_disk',
      'innodb_defragment'                     => '1',
      'innodb_defragment_n_pages'             => '7',
      'innodb_defragment_stats_accuracy'      => '0',
      'innodb_defragment_fill_factor_n_recs'  => '20',
      'innodb_defragment_fill_factor'         => '0.9',
      'innodb_defragment_frequency'           => '40',
    },
  }
  class { '::mysql::server':
    package_name            => 'MariaDB-server',
#    package_ensure          => '10.1.14',
    service_name            => 'mysql',
    root_password           => 'toor',
    remove_default_accounts => true,
    override_options        => $override_options
  }
  class { 'docker':
    version       => 'latest',
    docker_users  => [ 'vagrant', ],
  }
}

node 'buildsrv.tomekw.pl' {
  yum::group { 'Development Tools':
    ensure => present,
  }
  $enhancers = [ "yum-utils", "libevent-devel", "perl-Test-Simple", "cyrus-sasl-devel", "createrepo", "maven", "docker" ]
  package { $enhancers: ensure => "installed" }
  exec { 'install_remi_yum_repo':
    command => '/usr/bin/rpm -ihv --replacepkgs http://rpms.famillecollet.com/enterprise/remi-release-7.rpm',
  }
  include jenkins
  include jenkins::master
  jenkins::plugin { 'ant': } ->
  jenkins::plugin { 'antisamy-markup-formatter': } ->
  jenkins::plugin { 'copyartifact': } ->
  jenkins::plugin { 'credentials': } ->
  jenkins::plugin { 'cvs': } ->
  jenkins::plugin { 'external-monitor-job': } ->
  jenkins::plugin { 'envinject': } ->
  jenkins::plugin { 'git': } ->
  jenkins::plugin { 'git-client': } ->
  jenkins::plugin { 'icon-shim': } ->
  jenkins::plugin { 'javadoc': } ->
  jenkins::plugin { 'jquery': } ->
  jenkins::plugin { 'junit': } ->
  jenkins::plugin { 'ldap': } ->
  jenkins::plugin { 'mailer': } ->
  jenkins::plugin { 'mapdb-api': } ->
  jenkins::plugin { 'matrix-auth': } ->
  jenkins::plugin { 'matrix-project': } ->
  jenkins::plugin { 'maven-plugin': } ->
  jenkins::plugin { 'modernstatus': } ->
  jenkins::plugin { 'nodelabelparameter': } ->
  jenkins::plugin { 'pam-auth': } ->
  jenkins::plugin { 'pegdown-formatter': } ->
  jenkins::plugin { 'scm-api': } ->
  jenkins::plugin { 'script-security': } ->
  jenkins::plugin { 'ssh-credentials': } ->
  jenkins::plugin { 'ssh-slaves': } ->
  jenkins::plugin { 'subversion': } ->
  jenkins::plugin { 'token-macro': } ->
  jenkins::plugin { 'translation': } ->
  jenkins::plugin { 'windows-slaves': } ->
  jenkins::plugin { 'ws-cleanup': } ->
  jenkins::plugin { 'job-dsl': } ->
  jenkins::plugin { 'structs': }
}
