require 'spec_helper_acceptance'

# It is sometimes faster to host confluence / java files on a local webserver.
# Set environment variable download_url to use local webserver
# export download_url = 'http://10.0.0.XXX/'
download_url = ENV['download_url'] if ENV['download_url']
if ENV['download_url'] then
  download_url = ENV['download_url']
else 
  download_url = 'undef'
end
if download_url == 'undef' then
  java_url = "'http://download.oracle.com/otn-pub/java/jdk/7u71-b14/'"
else 
  java_url = download_url
end

describe 'confluence', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  it 'change params of server.xml' do
    pp = <<-EOS
      $jh = $osfamily ? {
        default   => '/opt/java',
      }
      if versioncmp($::puppetversion,'3.6.1') >= 0 {
        $allow_virtual_packages = hiera('allow_virtual_packages',false)
        Package {
          allow_virtual => $allow_virtual_packages,
        }
      }
      class { 'confluence':
        version             => '5.7',
        download_url        => #{download_url},
        javahome            => $jh,
        tomcat_port         => '8091',
        tomcat_max_threads  => 999,
        tomcat_accept_count => 999,
        context_path        => '/confluence1',
      }
    EOS
    apply_manifest(pp, :catch_failures => true)
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 localhost:8091/confluence1', :acceptable_exit_codes => [0]
    sleep 60
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 localhost:8091/confluence1', :acceptable_exit_codes => [0]
    sleep 30
    apply_manifest(pp, :catch_changes => true)
  end

  describe process("java") do
    it { should be_running }
  end

  describe port(8091) do
    it { is_expected.to be_listening }
  end

  describe service('confluence') do
    it { should be_enabled }
  end

  describe user('confluence') do
    it { should exist }
  end

  describe user('confluence') do
    it { should belong_to_group 'confluence' }
  end

  describe user('confluence') do
    it { should have_login_shell '/bin/true' }
  end

  describe command('wget -q --tries=240 --retry-connrefused --read-timeout=10 -O- localhost:8091/confluence1') do
    its(:stdout) { should match (/http\:\/\/www\.atlassian\.com\//) }
  end

  describe file('/opt/confluence/atlassian-confluence-5.7/conf/server.xml') do
    it { should contain "maxThreads=\"999\"" }
    it { should contain "acceptCount=\"999\"" }
    it { should contain "Context path=\"/confluence\"" }
  end

end
