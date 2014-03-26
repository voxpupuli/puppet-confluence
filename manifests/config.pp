# == Class: confluence
#
# Full description of class confluence here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { confluence:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
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
    content => template("confluence/server.xml.erb"),
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
