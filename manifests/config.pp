# == Class: confluence
#
# Install confluence, See README.md for more.
#
class confluence::config(
  $tomcat_port         = $confluence::tomcat_port,
  $tomcat_max_threads  = $confluence::tomcat_max_threads,
  $tomcat_accept_count = $confluence::tomcat_accept_count,
  $tomcat_proxy        = $confluence::tomcat_proxy,
  $tomcat_extras       = $confluence::tomcat_extras,
  $manage_server_xml   = $confluence::manage_server_xml,
) {

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
 
  if $manage_server_xml == 'augeas' {
    $_tomcat_max_threads  = { maxThreads  => $tomcat_max_threads }
    $_tomcat_accept_count = { acceptCount => $tomcat_accept_count }
    $_tomcat_port         = { port        => $tomcat_port }
  
    $parameters = merge($_tomcat_max_threads, $_tomcat_accept_count, $tomcat_proxy, $tomcat_extras, $_tomcat_port )
  
    if versioncmp($::augeasversion, '1.0.0') < 0 {
      fail('This module requires Augeas >= 1.0.0')
    }
  
    $path = "Server/Service[#attribute/name='Tomcat-Standalone']"
  
    if ! empty($parameters) {
      $_parameters = suffix(prefix(join_keys_to_values($parameters, " '"), "set ${path}/Connector/#attribute/"), "'")
    } else {
      $_parameters = undef
    }
  
    $changes = delete_undef_values([$_parameters])
  
    if ! empty($changes) {
      augeas { "${confluence::webappdir}/conf/server.xml":
        lens    => 'Xml.lns',
        incl    => "${confluence::webappdir}/conf/server.xml",
        changes => $changes,
      }
    }

  } elsif $manage_server_xml == 'template' {

    file { "${confluence::webappdir}/conf/server.xml":
      content => template('confluence/server.xml.erb'),
      mode    => '0600',
      require => Class['confluence::install'],
      notify  => Class['confluence::service'],
    }

  }
}
