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
      it { should contain_augeas('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml')}
    end
    context 'with param manage_server_xml set to template' do
      let(:params) {{
        :javahome          => '/opt/java',
        :version           => '5.5.6',
	:manage_server_xml => 'template',
      }}
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/bin/setenv.sh')}
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties')}
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml')}
    end
    context 'with param manage_server_xml set to ERROR' do
      let(:params) {{
        :javahome          => '/opt/java',
        :version           => '5.5.6',
	:manage_server_xml => 'ERROR',
      }}
      it('should fail') {
        should raise_error(Puppet::Error, /manage_server_xml must be "augeas" or "template"/)
      }
    end
    context 'with param manage_server_xml set to template and non default params' do
      let(:params) {{
        :javahome            => '/opt/java',
        :version             => '5.5.6',
	:manage_server_xml   => 'template',
        :tomcat_port         => 8089,
        :tomcat_max_threads  => 999,
        :tomcat_accept_count => 999,
        :tomcat_proxy        => {
          'scheme'      => 'https',
          'proxyName'   => 'EXAMPLE',
	  'proxyPort'   => '443',
	},
      }}
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/bin/setenv.sh')}
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties')}
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml')
        .with_content(/port="8089"/)
        .with_content(/maxThreads="999"/)
        .with_content(/acceptCount="999"/)
        .with_content(/scheme="https"/)
        .with_content(/proxyName="EXAMPLE"/)
        .with_content(/proxyPort="443"/)
      }
    end
  end
end
