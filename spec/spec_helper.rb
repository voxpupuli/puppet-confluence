require 'puppetlabs_spec_helper/module_spec_helper'
RSpec.configure do |c|
  c.default_facts = {
    :osfamily         => 'Debian',
    :augeasversion    => '1.0.0',
    :staging_http_get => 'curl',
    :path             => '/usr/local/bin:/usr/bin:/bin',
  }
end
