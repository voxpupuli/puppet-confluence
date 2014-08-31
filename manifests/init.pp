# == Class: confluence
#
# Install confluence, See README.md for more.
#
class confluence (

  # JVM Settings
  $javahome,
  $jvm_xms      = '256m',
  $jvm_xmx      = '1024m',
  $java_opts    = '',

  # Confluence Settings
  $version      = '5.4.4',
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
