# == Class: confluence::params
#
# Defines default values for confluence module
#
class confluence::params {

  case $facts['os']['family'] {
    /RedHat/: {
      if $facts['os']['release']['major'] == '7' {
        $service_file_location = '/usr/lib/systemd/system/confluence.service'
        $service_file_template = 'confluence/confluence.service.erb'
        $service_lockfile      = '/var/lock/subsys/confluence'
        $refresh_systemd       = true
      } elsif $facts['os']['release']['major'] == '6' {
        $service_file_location = '/etc/init.d/confluence'
        $service_file_template = 'confluence/confluence.initscript.erb'
        $service_lockfile      = '/var/lock/subsys/confluence'
        $refresh_systemd       = false
      } else {
        fail("Only osfamily ${facts['os']['family']} 6 and 7 and supported")
      }
    }
    /Debian/: {
      case $facts['os']['name'] {
        /Ubuntu/: {
          case $facts['os']['release']['major'] {
            /^16.04$/: {
              $service_file_location   = '/etc/systemd/system/confluence.service'
              $service_file_template   = 'confluence/confluence.service.erb'
              $service_lockfile        = '/var/lock/subsys/confluence'
              $refresh_systemd         = true
            }
            default: {
              $service_file_location   = '/etc/init.d/confluence'
              $service_file_template   = 'confluence/confluence.initscript.erb'
              $service_lockfile        = '/var/lock/confluence'
              $refresh_systemd         = false
            }
          }
        }
        default: {
          $service_file_location   = '/etc/init.d/confluence'
          $service_file_template   = 'confluence/confluence.initscript.erb'
          $service_lockfile        = '/var/lock/confluence'
          $refresh_systemd         = false
        }
      }
    }
    default: { fail('Only osfamily Debian and Redhat are supported') }
  }
}
