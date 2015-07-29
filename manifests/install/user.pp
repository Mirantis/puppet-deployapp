# == Class: deploy::install::user
#
# === Authors
#
# Scott Brimhall <sbrimhall@mirantis.com>
#
# === Copyright
#
# Copyright 2015 Mirantis Inc, unless otherwise noted.
#
class deploy::install::user (
  $user          = $::deploy::user,
) inherits ::deploy::install {

  # Validate parameters
  validate_string($user)

  # Setup deploy user if it doesn't exist already
  if ! defined(User[$user]) {
    user { $user:
      ensure     => 'present',
      shell      => '/bin/bash',
      home       => "/home/${user}",
      managehome => true,
    }
  }
}
