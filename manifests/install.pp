# == Class: confluence::install
#
# Full description of class confluence here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { confluence:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class confluence::install {

  require confluence
  require deploy

  group { $confluence::user: ensure => present, gid => $confluence::gid } ->
  user { $confluence::user:
    comment          => 'Confluence daemon account',
    shell            => '/bin/true',
    home             => $confluence::homedir,
    password         => '*',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
    system           => true,
    uid              => $confluence::uid,
    gid              => $confluence::gid,
  } ->

  deploy::file { "atlassian-${confluence::product}-${confluence::version}.${confluence::format}":
    target          => $confluence::webappdir,
    url             => $confluence::downloadURL,
    strip           => true,
    notify          => Exec["chown_${confluence::webappdir}"],
    owner           => $confluence::user,
    group           => $confluence::group,
    download_timout => 1800,
  } ->

  file { $confluence::homedir:
    ensure  => 'directory',
    owner   => $confluence::user,
    group   => $confluence::group,
  } ->

  exec { "chown_${confluence::webappdir}":
    command     => "/bin/chown -R ${confluence::user}:${confluence::group} ${confluence::webappdir}",
    refreshonly => true,
    subscribe   => User[$confluence::user]
  } ->

  file { '/etc/init.d/confluence':
    content => template('confluence/confluence.initscript.erb'),
    mode    => '0755',
  }

}
