# == Class: deploy::install::files
#
# === Authors
#
# Scott Brimhall <sbrimhall@mirantis.com>
#
# === Copyright
#
# Copyright 2015 Mirantis Inc, unless otherwise noted.
#
class deploy::install::files (
  $default_vhost   = $::deploy::default_vhost,
  $app_dir         = $::deploy::app_dir,
  $group           = $::deploy::group,
  $user            = $::deploy::user,
  $mode            = $::deploy::mode,
  $puppetmasters   = $::deploy::puppetmasters,
  $ssh_private_key = $::deploy::ssh_private_key,
) inherits ::deploy::install {

  # Setup app directory and docroot
  file { $app_dir:
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => $mode,
  }

  file { 'tmpdir':
    ensure => 'directory',
    path   => "${app_dir}/tmp",
    owner  => $user,
    group  => $group,
    mode   => $mode,
  }
  
  file { 'public':
    ensure => 'directory',
    path   => "${app_dir}/public",
    owner  => $user,
    group  => $group,
    mode   => $mode,
  }

  file { 'homedir':
    ensure => 'directory',
    path   => "/home/${user}",
    owner  => $user,
    group  => $group,
    mode   => $mode,
  }

  file { 'sshdir':
    ensure  => 'directory',
    path    => "/home/${user}/.ssh",
    owner   => $user,
    group   => $group,
    mode    => '0700',
    require => File['homedir'],
  }

  # Ensure passenger restart file exists
  file { 'restart-txt':
    ensure  => 'present',
    path    => "${app_dir}/tmp/restart.txt",
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => '',
  }

  # Setup Gemfile for app
  file { 'Gemfile':
    ensure  => 'file',
    path    => "${app_dir}/Gemfile",
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('deploy/Gemfile.erb'),
    notify  => Exec['bundle-install'],
  }

  file { 'config.ru':
    ensure  => 'file',
    path    => "${app_dir}/config.ru",
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('deploy/config.ru.erb'),
    notify  => Exec['restart-app'],
  }

  # Create an SSH key to use if one doesn't exist
  if $ssh_private_key == undef or empty($ssh_private_key) {
    exec { 'create-ssh-key':
      cwd     => "/home/${user}",
      user    => $user,
      command => '/bin/ssh-keygen -f ~/.ssh/id_rsa -t rsa -N \'\'',
      creates => "/home/${user}/.ssh/id_rsa",
    }
  }
  else {
    file { 'ssh_private_key':
      ensure  => 'file',
      owner   => $user,
      group   => $user,
      mode    => '0600',
      path    => "/home/${user}/.ssh/id_rsa",
      content => $ssh_private_key,
      require => File['sshdir'],
    }
  }

}
