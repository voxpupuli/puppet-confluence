require 'spec_helper.rb'

describe 'confluence' do
  describe 'confluence::mysql_connector' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end

          context 'mysql connector defaults' do
            let(:params) do
              {
                mysql_connector_version: '5.1.47',
                mysql_connector_install: '/opt/MySQL-connector',
                mysql_connector: true,
                javahome: '/opt/java'
              }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_file('/opt/MySQL-connector').with_ensure('directory') }
            it { is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.7.1/confluence/WEB-INF/lib/mysql-connector-java-5.1.47-bin.jar').with_ensure('file') }
          end

          context 'mysql_connector_manage equals false' do
            let(:params) do
              {
                mysql_connector_version: '5.1.47',
                mysql_connector_install: '/opt/MySQL-connector',
                mysql_connector: false,
                javahome: '/opt/java'
              }
            end

            it { is_expected.not_to contain_class('confluence::mysql_connector') }
          end
        end
      end
    end
  end
end
