# == Class: confluence::sso
#
# Install confluence SSO via crowd, See README.md for more.
#
class confluence::sso(
  $application_name = $::confluence::application_name,
  $application_password = $::confluence::application_password,
  $application_login_url = $::confluence::application_login_url,
  $crowd_server_url = $::confluence::crowd_server_url,
  $crowd_base_url = $::confluence::crowd_base_url,
  $session_isauthenticated = $::confluence::session_isauthenticated,
  $session_tokenkey = $::confluence::session_tokenkey,
  $session_validationinterval = $::confluence::session_validationinterval,
  $session_lastvalidation = $::confluence::session_lastvalidation,
) {

  validate_re($application_login_url,'^https?\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$')
  validate_re($crowd_server_url,'^https?\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$')
  validate_re($crowd_base_url,'^https?\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$')

  file { "${confluence::webappdir}/confluence/WEB-INF/classes/crowd.properties":
    ensure  => present,
    content => template('confluence/crowd.properties'),
    mode    => '0660',
    owner   => $::confluence::user,
    group   => $::confluence::group,
    require => Class['confluence::install'],
    notify  => Class['confluence::service'],
  }
  file { "${confluence::webappdir}/confluence/WEB-INF/classes/seraph-config.xml":
    source  => 'puppet:///modules/confluence/seraph-config_withSSO.xml',
    mode    => '0660',
    owner   => $::confluence::user,
    group   => $::confluence::group,
    require => Class['confluence::install'],
    notify  => Class['confluence::service'],
  }
}
