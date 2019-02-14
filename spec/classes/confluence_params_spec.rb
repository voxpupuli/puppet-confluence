require 'spec_helper.rb'

describe 'confluence' do
  describe 'confluence::params' do
    on_supported_os.each do |os, fs_facts|
      context "on #{os}" do
        let :facts do
          fs_facts
        end

        context 'default params' do
          let(:params) do
            {
              javahome: '/opt/java',
              version: '5.5.6'
            }
          end

          case os
          when 'centos-6-x86_64', 'redhat-6-x86_64', 'ubuntu-14.04-x86_64', 'debian-7-x86_64'
            it { is_expected.to contain_file('/etc/init.d/confluence') }
          when 'centos-7-x86_64', 'redhat-7-x86_64'
            it { is_expected.to contain_file('/usr/lib/systemd/system/confluence.service') }
          when 'ubuntu-16.04-x86_64', 'ubuntu-18.04-x86_64', 'debian-8-x86_64', 'debian-9-x86_64'
            it { is_expected.to contain_file('/etc/systemd/system/confluence.service') }
          end

          it { is_expected.to compile.with_all_deps }
        end
      end
    end
  end
end
