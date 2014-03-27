# == Class: confluence
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
class confluence (

  # JVM Settings
  $javahome,
  $jvm_xms      = '256m',
  $jvm_xmx      = '1024m',
  $java_opts    = '',

  # Confluence Settings
  $version      = '5.1.3',
  $product      = 'confluence',
  $format       = 'tar.gz',
  $installdir   = '/opt/confluence',
  $homedir      = '/home/confluence',
  $user         = 'confluence',
  $group        = 'confluence',
  $uid          = undef,
  $gid          = undef,

  # Misc Settings
  $downloadURL  = 'http://www.atlassian.com/software/confluence/downloads/binary/',

  # Manage confluence server
  $manage_service = true,

  # Reverse https proxy
  $proxy = {},

) {

  $webappdir    = "${installdir}/atlassian-${product}-${version}"
#  $dburl        = "jdbc:${db}://${dbserver}:${dbport}/${dbname}"

  include confluence::install
  include confluence::config
  include confluence::service

}
