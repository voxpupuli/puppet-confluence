# == Class: confluence::facts
#
# Deprecated will be removed in a future release
#
class confluence::facts {
  if $facts['puppetversion'] =~ /Puppet Enterprise/ {
    $dir = 'puppetlabs/'
  } else {
    $dir = ''
  }

  file { "/etc/${dir}facter/facts.d/confluence_facts.sh":
    ensure => absent,
  }
}
