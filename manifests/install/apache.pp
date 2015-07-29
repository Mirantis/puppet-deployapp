# == Class: deploy::install::apache
#
# === Authors
#
# Scott Brimhall <sbrimhall@mirantis.com>
#
# === Copyright
#
# Copyright 2015 Mirantis Inc, unless otherwise noted.
#
class deploy::install::apache {

  # Install Apache and mod_passenger
  if $::osfamily == 'RedHat' and $::operatingsystemrelease =~ /^7/ {
    class { '::apache':
      require => Package['foreman-release'],
    }
  }
  else {
    include ::apache
  }

  class { '::apache::mod::passenger': }

}
