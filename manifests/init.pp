# == Class: confluence
#
# Install confluence, See README.md for more.
#
class confluence (

  # JVM Settings
  $javahome     = undef,
  $jvm_xms      = '256m',
  $jvm_xmx      = '1024m',
  $jvm_permgen  = '256m',
  $java_opts    = '',

  # Confluence Settings
  $version      = '5.7.1',
  $product      = 'confluence',
  $format       = 'tar.gz',
  $installdir   = '/opt/confluence',
  $homedir      = '/home/confluence',
  $user         = 'confluence',
  $group        = 'confluence',
  $uid          = undef,
  $gid          = undef,
  $manage_user  = true,
  $shell        = '/bin/true',

  # Misc Settings
  $download_url  = 'http://www.atlassian.com/software/confluence/downloads/binary',
  $downloadURL   = undef,

  # Choose whether to use nanliu-staging, or mkrakowitzer-deploy
  # Defaults to nanliu-staging as it is puppetlabs approved.
  $staging_or_deploy = 'staging',

  # Manage confluence server
  $manage_service = true,

  # Tomcat Tunables
  # Should we use augeas to manage server.xml or a template file
  $manage_server_xml   = 'augeas',
  $tomcat_port         = 8090,
  $tomcat_max_threads  = 150,
  $tomcat_accept_count = 100,
  # Reverse https proxy setting for tomcat
  $tomcat_proxy = {},
  # Any additional tomcat params for server.xml
  $tomcat_extras = {},
  $context_path  = '',

  # Command to stop confluence in preparation to updgrade. This is configurable
  # incase the confluence service is managed outside of puppet. eg: using the
  # puppetlabs-corosync module: 'crm resource stop confluence && sleep 15'
  $stop_confluence = 'service confluence stop && sleep 15',

  # Enable confluence version fact for running instance
  # This required for upgrades
  $facts_ensure = 'present',
) {

  if $downloadURL {
    warning("${module_name}: The use of downloadURL is deprecated. Use download_url instead.")
    $real_download_url = $downloadURL
  } else {
    $real_download_url = $download_url
  }

  if $downloadURL and $download_url {
    fail ("${module_name}: You have specified both downloadURL and download_url. Use download_url only.")
  }

  validate_re($version, '^(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)(|[a-z])$')
  validate_absolute_path($installdir)
  validate_absolute_path($homedir)
  validate_bool($manage_user)

  validate_re($manage_server_xml, ['^augeas$', '^template$' ],
    'manage_server_xml must be "augeas" or "template"')
  validate_hash($tomcat_proxy)
  validate_hash($tomcat_extras)

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

  $webappdir    = "${installdir}/atlassian-${product}-${version}"

  if $::confluence_version {
    # If the running version of CONFLUENCE is less than the expected version of CONFLUENCE
    # Shut it down in preparation for upgrade.
    if versioncmp($version, $::confluence_version) > 0 {
      notify { 'Attempting to upgrade CONFLUENCE': }
      exec { $stop_confluence: before => Anchor['confluence::start'] }
    }
  }

  if $javahome == undef {
    fail('You need to specify a value for javahome')
  }

  anchor { 'confluence::start': } ->
  class { '::confluence::facts': } ->
  class { '::confluence::install': } ->
  class { '::confluence::config': } ~>
  class { '::confluence::service': } ->
  anchor { 'confluence::end': }
}
