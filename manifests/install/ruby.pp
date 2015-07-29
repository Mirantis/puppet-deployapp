# == Class: deploy::install::ruby
#
# === Authors
#
# Scott Brimhall <sbrimhall@mirantis.com>
#
# === Copyright
#
# Copyright 2015 Mirantis Inc, unless otherwise noted.
#
class deploy::install::ruby {

  # Make sure ruby is setup and we have rubygems installed
  include ::ruby

  if ! defined(Package['rubygems']) {
    package { 'rubygems':
      ensure => 'present',
    }
  }

  # Make sure bundle is setup so we can install our needed gems
  if ! defined(Package[bundle]) {
    package { 'bundle':
      ensure   => 'present',
      provider => 'gem',
    }
  }
}
