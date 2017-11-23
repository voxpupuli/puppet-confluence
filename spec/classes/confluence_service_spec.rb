require 'spec_helper.rb'

describe 'confluence' do
  describe 'confluence::config' do
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

          it { is_expected.to contain_service('confluence') }
          it { is_expected.to compile.with_all_deps }
        end
      end
    end
  end
end
