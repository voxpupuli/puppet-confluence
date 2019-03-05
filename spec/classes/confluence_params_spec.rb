require 'spec_helper.rb'

describe 'confluence' do
  describe 'confluence::params' do
    on_supported_os.each do |os, fs_facts|
      context "on #{os}" do
        let :facts do
          fs_facts
        end

        let(:params) do
          {
            javahome: '/opt/java',
            version: '5.5.6'
          }
        end

        context 'service_provider is systemd' do
          let :facts do
            fs_facts.merge(service_provider: 'systemd')
          end

          case os
          when %r{^centos}, %r{^redhat}
            it { is_expected.to contain_file('/usr/lib/systemd/system/confluence.service') }
          when %r{^ubuntu}, %r{^debian}
            it { is_expected.to contain_file('/etc/systemd/system/confluence.service') }
          end

          it { is_expected.to compile.with_all_deps }
        end

        context 'service_provider is not systemd' do
          it { is_expected.to contain_file('/etc/init.d/confluence') }
          it { is_expected.to compile.with_all_deps }
        end
      end
    end
  end
end
