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

  # Tomcat Tunables
  # Should we use augeas to manage server.xml or a template file
  $manage_server_xml   = 'augeas',
  $tomcat_port         = 8080,
  $tomcat_max_threads  = 150,
  $tomcat_accept_count = 100,
  # Reverse https proxy setting for tomcat
  $tomcat_proxy = {},
  # Any additional tomcat params for server.xml
  $tomcat_extras = {},

) {
  validate_re($version, '^(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)(|[a-z])$')
  validate_absolute_path($installdir)
  validate_absolute_path($homedir)

  validate_re($manage_server_xml, ['^augeas$', '^template$' ],
    'manage_server_xml must be "augeas" or "template"')
  validate_hash($tomcat_proxy)
  validate_hash($tomcat_extras)

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
