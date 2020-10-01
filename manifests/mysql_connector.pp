class confluence::mysql_connector (
  String $connector_version  = $confluence::mysql_connector_version,
  String $installpath        = $confluence::mysql_connector_install,
) {
  assert_private()

  if $confluence::proxy_server {
    class { 'mysql_java_connector':
      installdir   => $installpath,
      version      => $connector_version,
      proxy_server => $confluence::proxy_server,
    }
  } else {
    class { 'mysql_java_connector':
      installdir => $installpath,
      version    => $connector_version,
    }
  }

  file { "${confluence::installdir}/atlassian-confluence-${confluence::version}/confluence/WEB-INF/lib/mysql-connector-java-${connector_version}-bin.jar":
    ensure => file,
    source => "${installpath}/mysql-connector-java-${connector_version}/mysql-connector-java-${connector_version}-bin.jar",
    notify => Service['confluence'];
  }
}
