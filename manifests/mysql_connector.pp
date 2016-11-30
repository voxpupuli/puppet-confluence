# Class to install the MySQL Java connector
class confluence::mysql_connector (
  $version      = $confluence::mysql_connector_version,
  $product      = $confluence::mysql_connector_product,
  $format       = $confluence::mysql_connector_format,
  $installdir   = $confluence::mysql_connector_install,
  $download_url = $confluence::mysql_connector_url,
) {

  require ::staging

  $file = "${product}-${version}.${format}"

  if ! defined(File[$installdir]) {
    file { $installdir:
      ensure => 'directory',
      owner  => root,
      group  => root,
      before => Staging::File[$file],
    }
  }

  if ! defined(Staging::File[$file]) {
    staging::file { $file:
      source  => "${download_url}/${file}",
      timeout => 300,
    }
  }

  staging::extract { "confluence ${file}":
    source  => $file,
    target  => $installdir,
    creates => "${installdir}/${product}-${version}",
    require => Staging::File[$file],
  } ->
  file { "${confluence::webappdir}/lib/mysql-connector-java.jar":
    ensure => link,
    target => "${installdir}/${product}-${version}/${product}-${version}-bin.jar",
  }
}
