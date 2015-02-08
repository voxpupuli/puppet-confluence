# == Class: confluence
#
# Install confluence, See README.md for more.
#
class confluence (

  # JVM Settings
  $javahome,
  $jvm_xms      = '256m',
  $jvm_xmx      = '1024m',
  $jvm_permgen  = '256m',
  $java_opts    = '',

  # Confluence Settings
  $version      = '5.5.6',
  $product      = 'confluence',
  $format       = 'tar.gz',
  $installdir   = '/opt/confluence',
  $homedir      = '/home/confluence',
  $user         = 'confluence',
  $group        = 'confluence',
  $uid          = undef,
  $gid          = undef,

  # Misc Settings
  $downloadURL  = 'http://www.atlassian.com/software/confluence/downloads/binary',

  # Choose whether to use nanliu-staging, or mkrakowitzer-deploy
  # Defaults to nanliu-staging as it is puppetlabs approved.
  $staging_or_deploy = 'staging',

  # Manage confluence server
  $manage_service = true,

  # Reverse https proxy
  $proxy = {},

) {

  $webappdir    = "${installdir}/atlassian-${product}-${version}"

  anchor { 'confluence::start':
  } ->
  class { 'confluence::install':
  } ->
  class { 'confluence::config':
  } ~>
  class { 'confluence::service':
  } ->
  anchor { 'confluence::end': }

}
