require 'spec_helper.rb'

describe 'confluence' do
  describe 'confluence::config' do
    context 'default params' do
      let(:params) {{
        :javahome => '/opt/java',
        :version  => '5.5.6',
      }}
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/bin/setenv.sh')}
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties')}
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml')}
    end
  end
end
