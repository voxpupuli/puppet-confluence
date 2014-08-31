# == Class: confluence
#
# Install confluence, See README.md for more.
#
class confluence::config {

  File {
    owner => $confluence::user,
    group => $confluence::group,
  }

  file {"${confluence::webappdir}/bin/setenv.sh":
    ensure  => present,
    content => template('confluence/setenv.sh.erb'),
    mode    => '0755',
  } ~>

  file { "${confluence::webappdir}/confluence/WEB-INF/classes/confluence-init.properties":
    content => template('confluence/confluence-init.properties.erb'),
    mode    => '0755',
    require => Class['confluence::install'],
    notify  => Class['confluence::service'],
  }

  file { "${confluence::webappdir}/conf/server.xml":
    content => template('confluence/server.xml.erb'),
    mode    => '0600',
    require => Class['confluence::install'],
    notify  => Class['confluence::service'],
  }

#  file { "${confluence::homedir}/confluence/confluence.cfg.xml":
#    content => template("confluence/confluence.cfg.xml.erb"),
#    mode    => '0600',
#    require => [ Class['confluence::install'],File[$confluence::homedir] ],
#    notify  => Class['confluence::service'],
#  }

}
