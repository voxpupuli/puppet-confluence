# == Class: confluence::facts
#
# Class to add some facts for CONFLUENCE. They have been added as an external fact
# because we do not want to distrubute these facts to all systems.
#
# === Parameters
#
# [*port*]
#   port that confluence listens on.
# [*uri*]
#   ip that confluence is listening on, defaults to localhost.
#
# === Examples
#
# class { 'confluence::facts': }
#
class confluence::facts(
  $ensure = $confluence::facts_ensure
) inherits confluence::params {

  if $::puppetversion =~ /Puppet Enterprise/ {
    $dir      = 'puppetlabs/'
  } else {
    $dir      = ''
  }

  if ! defined(File["/etc/${dir}facter"]) {
    file { "/etc/${dir}facter":
      ensure  => directory,
    }
  }
  if ! defined(File["/etc/${dir}facter/facts.d"]) {
    file { "/etc/${dir}facter/facts.d":
      ensure  => directory,
    }
  }

  file { "/etc/${dir}facter/facts.d/confluence_facts.sh":
    ensure  => $ensure,
    content => template('confluence/facts.sh.erb'),
    mode    => '0500',
  }

}
