# == Class: confluence::service
#
# Install confluence, See README.md for more.
#
class confluence::service(
  $service_file_location = $confluence::params::service_file_location,
  $service_file_template = $confluence::params::service_file_template,
  $service_lockfile      = $confluence::params::service_lockfile,
  $refresh_systemd       = $confluence::params::refresh_systemd,
)  {

  file { $service_file_location:
    content => template($service_file_template),
    mode    => '0755',
  }

  if $refresh_systemd {
    exec { 'systemctl_reload_confluence':
      command     => 'systemctl daemon-reload',
      path        => '/bin:/sbin:/usr/bin:/usr/sbin',
      refreshonly => true,
      subscribe   => File[$service_file_location],
      before      => Service['confluence'],
    }
  }

  if $confluence::manage_service {
    service { 'confluence':
      ensure  => 'running',
      enable  => true,
      require => [ Class['confluence::config'], File[$service_file_location], ],
    }
  }
}
