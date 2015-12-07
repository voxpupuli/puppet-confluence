# == Class: confluence::service
#
# Install confluence, See README.md for more.
#
class confluence::service(
  $service_file_location = $confluence::params::service_file_location,
  $service_file_template = $confluence::params::service_file_template,
  $service_lockfile      = $confluence::params::service_lockfile,
)  {

  file { $service_file_location:
    content => template($service_file_template),
    mode    => '0755',
  }

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
