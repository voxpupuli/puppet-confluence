require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  on host, 'chmod 755 /root'
  next unless fact_on(host, 'osfamily') == 'Debian'
  on host, "echo \"en_US ISO-8859-1\nen_NG.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\n\" > /etc/locale.gen"
  on host, '/usr/sbin/locale-gen'
  on host, '/usr/sbin/update-locale'
end
