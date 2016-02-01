# == Class: confluence::install
#
# Install confluence, See README.md for more.
#
class confluence::install {

  if $::confluence::manage_user {
    group { $confluence::group: ensure => present, gid => $confluence::gid } ->

    user { $confluence::user:
      comment          => 'Confluence daemon account',
      shell            => $confluence::shell,
      home             => $confluence::homedir,
      password         => '*',
      password_min_age => '0',
      password_max_age => '99999',
      managehome       => true,
      system           => true,
      uid              => $confluence::uid,
      gid              => $confluence::gid,
    }
  }

  if ! defined(File[$confluence::installdir]) {
    file { $confluence::installdir:
      ensure => 'directory',
      owner  => $confluence::user,
      group  => $confluence::group,
    }
  }

  $file = "atlassian-${confluence::product}-${confluence::version}.${confluence::format}"

  if $confluence::staging_or_deploy == 'staging' {

    require staging

    if ! defined(File[$confluence::webappdir]) {
      file { $confluence::webappdir:
        ensure => 'directory',
        owner  => $confluence::user,
        group  => $confluence::group,
      }
    }

    staging::file { $file:
      source  => "${confluence::real_download_url}/${file}",
      timeout => 1800,
    } ->

    staging::extract { $file:
      target  => $confluence::webappdir,
      creates => "${confluence::webappdir}/conf",
      strip   => 1,
      user    => $confluence::user,
      group   => $confluence::group,
      notify  => Exec["chown_${confluence::webappdir}"],
      before  => File[$confluence::homedir],
      require => [
        File[$confluence::installdir],
        User[$confluence::user],
        File[$confluence::webappdir] ],
    }

  } elsif $confluence::staging_or_deploy == 'deploy' {

    require deploy

    deploy::file { $file:
      target          => $confluence::webappdir,
      url             => $confluence::real_download_url,
      strip           => true,
      download_timout => 1800,
      owner           => $confluence::user,
      group           => $confluence::group,
      notify          => Exec["chown_${confluence::webappdir}"],
      before          => File[$confluence::homedir],
      require         => [ File[$confluence::installdir], User[$confluence::user] ],
    }

  } else {
    fail('staging_or_deploy must equal "staging" or "deploy"')
  }

  file { $confluence::homedir:
    ensure => 'directory',
    owner  => $confluence::user,
    group  => $confluence::group,
  } ->

  exec { "chown_${confluence::webappdir}":
    command     => "/bin/chown -R ${confluence::user}:${confluence::group} ${confluence::webappdir}",
    refreshonly => true,
    subscribe   => User[$confluence::user]
  }

}
