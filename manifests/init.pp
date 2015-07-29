# == Class: deploy
#
# This class sets up a sinatra app that listens for environments
# and modules to deploy to Puppetmasters via r10k 
#
# === Parameters
#
# $default_vhost
#   Whether to use this as the default vhost when a request doesn't match any
#   other vhosts. Defaults to true.
#
# $vhost
#   The fqdn to use for the apache vhost.  Defaults to ${::fqdn}.
#
# $app_dir
#   The directory to deploy the app into. Defaults to /home/deploy/app.
#
# $group
#   The group for the app. Defaults to 'deploy'.
#
# $user
#   The user for the app. Defaults to 'deploy'.
#
# $mode
#   The docroot mode. Defaults to '0755'.
#
# $port
#   The port the app will listen on. Defaults to 9292.
#
# $puppetmasters
#   A hash of puppetmasters to deploy to. These must have an SSH trust setup
#   for the user you are deploying to!
#
# $ssh_private_key
#   The private key to setup for the user. DO NOT put this in plain text. Use at
#   a minimum hiera-eyaml
#
# === Examples
#
#  $config = hiera('deploy::config')
#
#  class { 'deploy':
#    default_vhost => $config[default_vhost],
#    app_dir       => $config[app_dir],
#    group         => $config[group],
#    user          => $config[user],
#    mode          => $config[mode],
#    puppetmasters => $config[puppetmasters]
#  }
#
# === Authors
#
# Scott Brimhall <sbrimhall@mirantis.com>
#
# === Copyright
#
# Copyright 2015 Mirantis Inc, unless otherwise noted.
#
class deploy (
  $default_vhost = $::deploy::params::default_vhost,
  $vhost           = $::deploy::params::vhost,
  $app_dir         = $::deploy::params::app_dir,
  $group           = $::deploy::params::group,
  $user            = $::deploy::params::user,
  $mode            = $::deploy::params::mode,
  $port            = $::deploy::params::port,
  $puppetmasters   = $::deploy::params::puppetmasters,
  $ssh_private_key = undef,
) inherits ::deploy::params {

  # Validate parameters
  validate_bool($default_vhost)
  validate_string($app_dir)
  validate_string($group)
  validate_string($user)
  validate_string($mode)
  validate_string($port)
  validate_array($puppetmasters)

  # Call private classes to install and configure the app
  include ::deploy::install
  include ::deploy::config

  # Order them the way we want
  Class['::deploy::install'] ->
  Class['::deploy::config']

}
