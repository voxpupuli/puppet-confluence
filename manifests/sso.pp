# == Class: confluence::sso
#
# Install confluence SSO via crowd, See README.md for more.
#
class confluence::sso (
  $application_name                                                = $confluence::application_name,
  $application_password                                            = $confluence::application_password,
  Variant[Stdlib::HTTPSUrl,Stdlib::HTTPUrl] $application_login_url = $confluence::application_login_url,
  Variant[Stdlib::HTTPSUrl,Stdlib::HTTPUrl] $crowd_server_url      = $confluence::crowd_server_url,
  Variant[Stdlib::HTTPSUrl,Stdlib::HTTPUrl] $crowd_base_url        = $confluence::crowd_base_url,
  $session_isauthenticated                                         = $confluence::session_isauthenticated,
  $session_tokenkey                                                = $confluence::session_tokenkey,
  $session_validationinterval                                      = $confluence::session_validationinterval,
  $session_lastvalidation                                          = $confluence::session_lastvalidation,
) {
  file { "${confluence::webappdir}/confluence/WEB-INF/classes/crowd.properties":
    ensure  => file,
    content => template('confluence/crowd.properties'),
    mode    => '0660',
    owner   => $confluence::user,
    group   => $confluence::group,
    require => Class['confluence::install'],
    notify  => Class['confluence::service'],
  }
  file { "${confluence::webappdir}/confluence/WEB-INF/classes/seraph-config.xml":
    source  => 'puppet:///modules/confluence/seraph-config_withSSO.xml',
    mode    => '0660',
    owner   => $confluence::user,
    group   => $confluence::group,
    require => Class['confluence::install'],
    notify  => Class['confluence::service'],
  }
}
