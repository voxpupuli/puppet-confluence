require 'spec_helper_acceptance'

# It is sometimes faster to host confluence / java files on a local webserver.
# Set environment variable download_url to use local webserver
# export download_url = 'http://10.0.0.XXX/'
download_url = ENV['download_url'] if ENV['download_url']
download_url = if ENV['download_url']
                 ENV['download_url']
               else
                 'undef'
               end
java_url = if download_url == 'undef'
             'http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-x64.tar.gz'
           else
             download_url
           end

describe 'confluence', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'installs with defaults' do
    pp = <<-EOS
      $jh = $osfamily ? {
        default => '/opt/java',
      }
      if versioncmp($::puppetversion,'3.6.1') >= 0 {
        $allow_virtual_packages = hiera('allow_virtual_packages',false)
        Package {
          allow_virtual => $allow_virtual_packages,
        }
      }
      file { $jh:
        ensure => 'directory',
      } ->
      archive { '/tmp/jdk-7u71-linux-x64.tar.gz':
        ensure          => present,
        extract         => true,
        extract_command => 'tar xfz %s --strip-components=1',
        extract_path    => $jh,
        source          => "#{java_url}",
        creates         => "${jh}/bin",
        cleanup         => true,
        cookie          => 'oraclelicense=accept-securebackup-cookie',
      } ->
      class { 'confluence':
        version      => '5.5.6',
        checksum     => 'a9f3f7ae42cce92e1f4a55cb6484bb5f',
        download_url => #{download_url},
        javahome     => $jh,
      }
    EOS
    apply_manifest(pp, catch_failures: true)
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 localhost:8090', acceptable_exit_codes: [0]
    sleep 60
    shell 'wget -q --tries=240 --retry-connrefused --read-timeout=10 localhost:8090', acceptable_exit_codes: [0]
    sleep 30
    apply_manifest(pp, catch_changes: true)
  end

  describe process('java') do
    it { is_expected.to be_running }
  end

  describe port(8090) do
    it { is_expected.to be_listening }
  end

  describe service('confluence') do
    it { is_expected.to be_enabled }
  end

  describe user('confluence') do
    it { is_expected.to exist }
  end

  describe user('confluence') do
    it { is_expected.to belong_to_group 'confluence' }
  end

  describe user('confluence') do
    it { is_expected.to have_login_shell '/bin/true' }
  end

  describe command('wget -q --tries=240 --retry-connrefused --read-timeout=10 -O- localhost:8090') do
    its(:stdout) { is_expected.to match %r{http://www.atlassian.com/} }
  end
end
