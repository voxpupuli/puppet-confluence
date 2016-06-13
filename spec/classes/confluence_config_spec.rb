require 'spec_helper.rb'

describe 'confluence' do
  describe 'confluence::config' do
    context 'default params' do
      let(:params) do
        {
          javahome: '/opt/java',
          version: '5.5.6'
        }
      end
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/bin/setenv.sh') }
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties') }
      it { should contain_augeas('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml') }
    end
    context 'with param manage_server_xml set to template' do
      let(:params) do
        {
          javahome: '/opt/java',
          version: '5.5.6',
          manage_server_xml: 'template'
        }
      end
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/bin/setenv.sh') }
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties') }
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml') }
    end
    context 'with param manage_server_xml set to ERROR' do
      let(:params) do
        {
          javahome: '/opt/java',
          version: '5.5.6',
          manage_server_xml: 'ERROR'
        }
      end
      it('fails') {
        should raise_error(Puppet::Error, %r{manage_server_xml must be "augeas" or "template"})
      }
    end
    context 'with param manage_server_xml set to template and non default params' do
      let(:params) do
        {
          javahome: '/opt/java',
          version: '5.5.6',
          manage_server_xml: 'template',
          context_path: '/confluence1',
          tomcat_port: 8089,
          tomcat_max_threads: 999,
          tomcat_accept_count: 999,
          tomcat_proxy: {
            'scheme'      => 'https',
            'proxyName'   => 'EXAMPLE',
            'proxyPort'   => '443'
          }
        }
      end
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/bin/setenv.sh') }
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties') }
      it { should contain_file('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml')
        .with_content(%r{port="8089"})
        .with_content(%r{maxThreads="999"})
        .with_content(%r{acceptCount="999"})
        .with_content(%r{scheme="https"})
        .with_content(%r{proxyName="EXAMPLE"})
        .with_content(%r{proxyPort="443"})
        .with_content(%r{Context path="/confluence1"})
      }
    end
  end
end
