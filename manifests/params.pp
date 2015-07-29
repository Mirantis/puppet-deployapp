# == Class: deploy::params
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
# $puppetmasters
#   A hash of puppetmasters to deploy to. These must have an SSH trust setup
#   for the user you are deploying to!
#
# === Authors
#
# Scott Brimhall <sbrimhall@mirantis.com>
#
# === Copyright
#
# Copyright 2015 Mirantis Inc, unless otherwise noted.
#
class deploy::params {

  $default_vhost = true
  $vhost         = $::fqdn
  $user          = 'deploy'
  $app_dir       = "/home/${user}/app"
  $group         = $user
  $mode          = '0755'
  $port          = '9292'
  $puppetmasters = ['puppet']

}
