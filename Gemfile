source 'https://rubygems.org'
if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 3.4.2']
end
gem 'rake'
gem 'puppet-lint'
gem 'rspec'
gem 'rspec-puppet', "~> 2"
gem 'puppetlabs_spec_helper'
gem 'puppet', puppetversion
gem 'puppet-blacksmith'
gem 'beaker'
gem 'pry'
gem 'serverspec'
gem 'beaker-rspec'
gem 'minitest'
gem 'guard-rake'
gem "metadata-json-lint"
gem "rspec-puppet-facts"
