# == Class: confluence::params
#
# Defines default values for confluence module
#
class confluence::params {

  case $facts['service_provider'] {
    'systemd': {
      case $facts['os']['family'] {
        /RedHat/: {
          $service_file_location = '/usr/lib/systemd/system/confluence.service'
          $service_file_template = 'confluence/confluence.service.erb'
          $refresh_systemd       = true
        }
        /Debian/: {
          $service_file_location = '/etc/systemd/system/confluence.service'
          $service_file_template = 'confluence/confluence.service.erb'
          $refresh_systemd       = true
        }
        default: { fail('Only osfamily Debian and Redhat are supported for systemd') }
      }
    }
    default: {
      $service_file_location = '/etc/init.d/confluence'
      $service_file_template = 'confluence/confluence.initscript.erb'
      $refresh_systemd       = false
    }
  }

}
