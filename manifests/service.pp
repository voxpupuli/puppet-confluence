# == Class: confluence::service
#
# Install confluence, See README.md for more.
#
class confluence::service(
  $service_file_location = $params::service_file_location,
  $service_file_template = $params::service_file_template,
  $service_lockfile      = $params::service_lockfile,
)  {
  if $confluence::manage_service {
    service { 'confluence':
      ensure  => 'running',
      enable  => true,
      start   => '/etc/init.d/confluence start',
      restart => '/etc/init.d/confluence restart',
      stop    => '/etc/init.d/confluence stop',
      status  => '/etc/init.d/confluence status',
      require => Class['confluence::config'],
    }
  }
}
