# == Class: deploy::install
#
# === Authors
#
# Scott Brimhall <sbrimhall@mirantis.com>
#
# === Copyright
#
# Copyright 2015 Mirantis Inc, unless otherwise noted.
#
class deploy::config (
  $default_vhost = $::deploy::default_vhost,
  $vhost         = $::deploy::vhost,
  $app_dir       = $::deploy::app_dir,
  $group         = $::deploy::group,
  $user          = $::deploy::user,
  $mode          = $::deploy::mode,
  $port          = $::deploy::port,
  $puppetmasters = $::deploy::puppetmasters,
) inherits ::deploy {

  exec { 'restart-app':
    command     => "/usr/bin/touch \"${app_dir}/tmp/restart.txt\"",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin',
    refreshonly => true,
    subscribe   => File[['app-config', 'app']],
  }
  
  file { 'app-config':
    path    => "${app_dir}/config.yaml",
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('deploy/config.yaml.erb'),
    notify  => Exec['restart-app'],
  }

  file { 'app':
    path    => "${app_dir}/deploy.rb",
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('deploy/deploy.rb.erb'),
    notify  => Exec['restart-app'],
  }

  apache::vhost { $vhost:
    ensure         => 'present',
    default_vhost  => $default_vhost,
    docroot        => "${app_dir}/public",
    docroot_group  => $group,
    docroot_owner  => $user,
    manage_docroot => false,
    directories    => [
      { path              => "${app_dir}/public",
        passenger_enabled => 'on',
      },
    ],
    port           => $port,
  }

}
