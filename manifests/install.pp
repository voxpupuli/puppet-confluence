# == Class: confluence::install
#
# Install confluence, See README.md for more.
#
class confluence::install {

  require deploy

  group { $confluence::user: ensure => present, gid => $confluence::gid } ->
  user { $confluence::user:
    comment          => 'Confluence daemon account',
    shell            => '/bin/true',
    home             => $confluence::homedir,
    password         => '*',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
    system           => true,
    uid              => $confluence::uid,
    gid              => $confluence::gid,
  }

  if ! defined(File[$confluence::installdir]) {
    file { $confluence::installdir:
      ensure => 'directory',
      owner  => $confluence::user,
      group  => $confluence::group,
    }
  }

  deploy::file { "atlassian-${confluence::product}-${confluence::version}.${confluence::format}":
    target          => $confluence::webappdir,
    url             => $confluence::downloadURL,
    strip           => true,
    notify          => Exec["chown_${confluence::webappdir}"],
    owner           => $confluence::user,
    group           => $confluence::group,
    download_timout => 1800,
    require         => [ File[$confluence::installdir], User[$confluence::user] ],
  } ->

  file { $confluence::homedir:
    ensure => 'directory',
    owner  => $confluence::user,
    group  => $confluence::group,
  } ->

  exec { "chown_${confluence::webappdir}":
    command     => "/bin/chown -R ${confluence::user}:${confluence::group} ${confluence::webappdir}",
    refreshonly => true,
    subscribe   => User[$confluence::user]
  } ->

  file { '/etc/init.d/confluence':
    content => template('confluence/confluence.initscript.erb'),
    mode    => '0755',
  }

}
