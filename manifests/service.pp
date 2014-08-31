# == Class: confluence::service
#
# Install confluence, See README.md for more.
#
class confluence::service {
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
