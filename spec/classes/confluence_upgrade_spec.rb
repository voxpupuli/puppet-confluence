require 'spec_helper.rb'

describe 'confluence' do
  on_supported_os.each do |os, fs_facts|
    context "on #{os}" do
      let :facts do
        fs_facts
      end

      describe 'confluence::install' do
        context 'default params' do
          let(:params) do
            {
              javahome: '/opt/java'
            }
          end
          let(:facts) do
            fs_facts.merge(confluence_version: '1.5.4')
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_exec('service confluence stop && sleep 15') }
        end
        context 'custom params' do
          let(:params) do
            {
              javahome: '/opt/java',
              stop_confluence: 'stop service please'
            }
          end
          let(:facts) do
            fs_facts.merge(confluence_version: '2.3.4a')
          end

          it { is_expected.to contain_exec('stop service please') }
        end
      end
    end
  end
end
