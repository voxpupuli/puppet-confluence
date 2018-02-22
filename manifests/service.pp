# == Class: confluence::service
#
# Install confluence, See README.md for more.
#
class confluence::service (
  $service_file_location = $confluence::params::service_file_location,
  $service_file_template = $confluence::params::service_file_template,
  $service_lockfile      = $confluence::params::service_lockfile,
  $refresh_systemd       = $confluence::params::refresh_systemd,
) {

  if($refresh_systemd) {
    exec { 'refresh_systemd_confluence':
      command     => 'systemctl daemon-reload',
      refreshonly => true,
      subscribe   => File[$service_file_location],
      before      => Service['confluence'],
    }
  }

  file { $service_file_location:
    content => template($service_file_template),
    mode    => '0755',
  }

  if $confluence::manage_service {
    service { 'confluence':
      ensure  => 'running',
      enable  => true,
      require => [ Class['confluence::config'], File[$service_file_location], ],
    }
  }
}
