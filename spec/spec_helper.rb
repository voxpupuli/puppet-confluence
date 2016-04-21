require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

require 'puppetlabs_spec_helper/module_spec_helper'
RSpec.configure do |c|
  c.default_facts = {
    osfamily: 'Debian',
    augeasversion: '1.0.0',
    staging_http_get: 'curl',
    path: '/usr/local/bin:/usr/bin:/bin',
    confluence_version: '5.5.6',
    puppetversion: '3.7.4',
  }
end
