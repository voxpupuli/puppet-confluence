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

  file { $service_file_location:
    content => template($service_file_template),
    mode    => '0755',
    notify  => [
      $refresh_systemd ? {
        true    => Exec["${title}-systemd-reload"],
        default => undef
      }
    ],
  }

  # Reload systemd
  exec { "${title}-systemd-reload":
    command     => 'systemctl daemon-reload',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }

  if $confluence::manage_service {
    service { 'confluence':
      ensure  => 'running',
      enable  => true,
      require => [ Class['confluence::config'], File[$service_file_location], ],
    }
  }
}
