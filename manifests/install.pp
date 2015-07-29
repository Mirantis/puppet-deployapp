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
class deploy::install (
  $default_vhost   = $::deploy::default_vhost,
  $app_dir         = $::deploy::app_dir,
  $group           = $::deploy::group,
  $user            = $::deploy::user,
  $mode            = $::deploy::mode,
  $puppetmasters   = $::deploy::puppetmasters,
  $ssh_private_key = $::deploy::ssh_private_key
) inherits ::deploy {

  include ::deploy::install::user
  include ::deploy::install::ruby
  include ::deploy::install::files
  include ::deploy::install::yum
  include ::deploy::install::apache

  Class['::deploy::install::user'] ->
  Class['::deploy::install::ruby'] ->
  Class['::deploy::install::files'] ->
  Class['::deploy::install::yum'] ->
  Class['::deploy::install::apache']
  
  # Bundle install the needed gems for the app
  exec { 'bundle-install':
    command     => "cd ${app_dir} ; bundle install",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin',
    refreshonly => true,
    subscribe   => File['Gemfile'],
  }

}
