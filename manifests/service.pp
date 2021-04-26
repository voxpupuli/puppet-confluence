# == Class: confluence::service
#
# Install confluence, See README.md for more.
#
class confluence::service (
  $service_file_location = $confluence::params::service_file_location,
  $service_file_template = $confluence::params::service_file_template,
  $refresh_systemd       = $confluence::params::refresh_systemd,
) {
  # Since Puppet 6.1.0 it's no longer needed to run daemon-reload manually when restarting a service. That means it's possible to drop this code. Since Puppet 4 & 5 are now EOL, this should be ok.
  # https://github.com/camptocamp/puppet-systemd/pull/171
  if($refresh_systemd and versioncmp($facts['puppetversion'], '6.1.0') < 0) {
    include systemd::systemctl::daemon_reload
    File[$service_file_location] ~> Class['systemd::systemctl::daemon_reload']
  }

  file { $service_file_location:
    content => template($service_file_template),
    mode    => '0755',
  }

  if $confluence::manage_service {
    service { 'confluence':
      ensure  => 'running',
      enable  => true,
      require => [Class['confluence::config'], File[$service_file_location], ],
    }
  }
}
