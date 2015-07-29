# deploy

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with deploy](#setup)
    * [What deploy affects](#what-deploy-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with deploy](#beginning-with-deploy)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Module to deploy sinatra app that deploys code to puppetmasters via r10k

## Module Description

This module deploys a sinatra application 'Deploy' that listens for an environment
or module to be passed to it to deploy via R10k.  It has a yaml config of puppetmasters
to deploy to.  SSH trusts must be setup between the puppetmasters and the user running the
sinatra app for this app to work.

This app is used to receive communication from a CI/CD service after successful job builds.
It then deploys the tested code to the puppetmasters.

## Setup

### What deploy affects

* ruby, apache, passenger, user for deploy app, rubygems 

### Setup Requirements

* SSH trust **MUST** be setup between the user that runs the sinatra app and puppetmasters running r10k 

### Beginning with deploy

If you'd like to use the deploy app with all of the default settings and default puppetmaster of 'puppet',
then all you need to do is include it.  You can declare it as a class and pass parameters to it from
hiera configuration as well.

## Usage

The following code will setup the app using hiera config data:

```
$config = hiera('deploy::config')

class { '::deploy':
  default_vhost => $config[default_vhost],
  user          => $config[user],
  puppetmasters => $config[puppetmasters]
}
```

If you just want the defaults (will only use the puppetmaster 'puppet'):

```include ::deploy```

## Reference

###Public classes:
```
deploy - Class for setting up deploy sinatra app
```

###Private classes:
```
deploy::install - Class that includes other private classes for installing files, apps, gems, etc to make the app work
deploy::install::users - Class that ensures the deploy user is setup if not already defined
deploy::install::ruby - Class that ensures that ruby is installed and that rubygems and bundle is installed
deploy::install::apache - Class that installs apache via puppetlabs-apache with mod_passenger included
deploy::install::files - Class that sets up directories and files necessary for the app
deploy::install::yum - Class that sets up additional yum repos, as needed. Currently only needed for CentOS 7 where there is no mod_passenger package outside of foreman-release repo.
deploy::config - Class that does the actual app configuration and declares the apache vhost for use with passenger
```

## Limitations

This has only been tested on CentOS 7 so far

## Development

Fork it, commit to your liking, and then submit a pull request
