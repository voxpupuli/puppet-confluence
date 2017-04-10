# == Class: confluence
#
# Install confluence, See README.md for more.
#
class confluence::config(
  $tomcat_port                     = $confluence::tomcat_port,
  $tomcat_max_threads              = $confluence::tomcat_max_threads,
  $tomcat_accept_count             = $confluence::tomcat_accept_count,
  $tomcat_proxy                    = $confluence::tomcat_proxy,
  $tomcat_extras                   = $confluence::tomcat_extras,
  $tomcat_jdbc_settings            = $confluence::tomcat_jdbc_settings,
  $manage_server_xml               = $confluence::manage_server_xml,
  $context_path                    = $confluence::context_path,
  $ajp                             = $confluence::ajp,
) {

  File {
    owner => $confluence::user,
    group => $confluence::group,
  }

  file {"${confluence::webappdir}/bin/setenv.sh":
    ensure  => present,
    content => template('confluence/setenv.sh.erb'),
    mode    => '0755',
  }
  ~> file { "${confluence::webappdir}/confluence/WEB-INF/classes/confluence-init.properties":
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

    if versioncmp($facts['augeasversion'], '1.0.0') < 0 {
      fail('This module requires Augeas >= 1.0.0')
    }

    $path = "Server/Service[#attribute/name='Tomcat-Standalone']"

    if ! empty($parameters) {
      $_parameters = suffix(prefix(join_keys_to_values($parameters, " '"), "set ${path}/Connector/#attribute/"), "'")
    } else {
      $_parameters = undef
    }

    ###
    # configure external tomcat datasource. See, for example:
    # https://confluence.atlassian.com/doc/configuring-a-mysql-datasource-in-apache-tomcat-1867.html
    ###
    # Step 3. Configure Tomcat: Set the JDBC Resource for external database.

    $jdbc_path = "${path}/Engine/Host/Context[#attribute/path='${context_path}']/Resource/#attribute"

    if ! empty($tomcat_jdbc_settings) {
      $_jdbc = suffix(prefix(join_keys_to_values($tomcat_jdbc_settings, " '"), "set ${jdbc_path}/"), "'")
    }
    $_context_path_changes = "set ${path}/Engine/Host/Context[#attribute/docBase=\"../confluence\"]/#attribute/path '${context_path}'"

    $changes = delete_undef_values([$_parameters, $_context_path_changes, $_jdbc])

    if ! empty($changes) {
      augeas { "${confluence::webappdir}/conf/server.xml":
        lens    => 'Xml.lns',
        incl    => "${confluence::webappdir}/conf/server.xml",
        changes => $changes,
      }
    }

    # Step 4. Configure the Confluence web application
    $conf_changes =
    [
     'set web-app/resource-ref/description/#text "Connection Pool"',
     'set web-app/resource-ref/res-ref-name/#text "jdbc/confluence"',
     'set web-app/resource-ref/res-type/#text "javax.sql.DataSource"',
     'set web-app/resource-ref/res-auth/#text "Container"',
     ]

    augeas {"${confluence::webappdir}/confluence/WEB-INF/web.xml":
      lens    => 'Xml.lns',
      incl    => "${confluence::webappdir}/confluence/WEB-INF/web.xml",
      changes => $conf_changes,
    }

  } elsif $manage_server_xml == 'template' {

    file { "${confluence::webappdir}/conf/server.xml":
      content => template('confluence/server.xml.erb'), # XXX need to fix this and add web.xml
      mode    => '0600',
      require => Class['confluence::install'],
      notify  => Class['confluence::service'],
    }
  }
  # if JDBC was configured along with the license key and server_id, skip some server setup steps.
  if $confluence::tomcat_jdbc_settings and $confluence::license and $confluence::server_id {
    file { "${confluence::homedir}/confluence.cfg.xml":
      content => template('confluence/confluence.cfg.xml.erb'),
      mode    => '0600',
      owner   => 'confluence',
      group   => 'confluence',
      require => Class['confluence::install'],
      notify  => Class['confluence::service'],
    }
  }
}
