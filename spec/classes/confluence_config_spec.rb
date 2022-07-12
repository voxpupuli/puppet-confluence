require 'spec_helper.rb'

describe 'confluence' do
  on_supported_os.each do |os, fs_facts|
    context "on #{os}" do
      let :facts do
        fs_facts
      end

      describe 'confluence::config' do
        context 'default params' do
          let(:params) do
            {
              javahome: '/opt/java',
              version: '5.5.6'
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/bin/setenv.sh') }
          it { is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties') }
          it { is_expected.to contain_augeas('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml') }
        end
        context 'with param manage_server_xml set to template' do
          let(:params) do
            {
              javahome: '/opt/java',
              version: '5.5.6',
              manage_server_xml: 'template'
            }
          end

          it { is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/bin/setenv.sh') }
          it { is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties') }
          it { is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml') }
        end
        context 'with param manage_server_xml set to template and non default params' do
          let(:params) do
            {
              javahome: '/opt/java',
              version: '5.5.6',
              manage_server_xml: 'template',
              context_path: '/confluence1',
              tomcat_port: 8089,
              tomcat_redirect_port: 443,
              tomcat_max_threads: 999,
              tomcat_accept_count: 999,
              tomcat_proxy: {
                'scheme'      => 'https',
                'proxyName'   => 'EXAMPLE',
                'proxyPort'   => '443'
              }
            }
          end

          it { is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/bin/setenv.sh') }
          it { is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties') }
          it do
            is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml').
              with_content(%r{port="8089"}).
              with_content(%r{redirectPort="443"}).
              with_content(%r{maxThreads="999"}).
              with_content(%r{acceptCount="999"}).
              with_content(%r{scheme="https"}).
              with_content(%r{proxyName="EXAMPLE"}).
              with_content(%r{proxyPort="443"}).
              with_content(%r{Context path="/confluence1"})
          end
        end
        context 'with param data_dir set' do
          let(:params) do
            {
              javahome: '/opt/java',
              version: '5.5.6',
              data_dir: '/opt/confluence/confluence-data'
            }
          end

          it do
            is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties').
              with_content(%r{confluence.home=/opt/confluence/confluence-data})
          end
        end
        context 'with param data_dir not set and param homdir set' do
          let(:params) do
            {
              javahome: '/opt/java',
              version: '5.5.6',
              homedir: '/opt/confluence/confluence-home'
            }
          end

          it do
            is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties').
              with_content(%r{confluence.home=/opt/confluence/confluence-home})
          end
        end
        context 'with param data_dir set and param homdir set' do
          let(:params) do
            {
              javahome: '/opt/java',
              version: '5.5.6',
              data_dir: '/opt/confluence/confluence-data',
              homedir: '/opt/confluence/confluence-home'
            }
          end

          it do
            is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/confluence/WEB-INF/classes/confluence-init.properties').
              with_content(%r{confluence.home=/opt/confluence/confluence-data})
          end
        end
        context 'ajp proxy' do
          let(:params) do
            {
              version: '5.5.6',
              javahome: '/opt/java',
              manage_server_xml: 'template',
              ajp: {
                'port'     => '8009',
                'protocol' => 'AJP/1.3'
              }
            }
          end

          it do
            is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml').
              with_content(%r{<Connector enableLookups="false" URIEncoding="UTF-8"\s+port = "8009"\s+protocol = "AJP/1.3"\s+/>})
          end
        end

        context 'tomcat additional connectors' do
          let(:params) do
            {
              version: '5.5.6',
              javahome: '/opt/java',
              manage_server_xml: 'template',
              tomcat_additional_connectors: {
                8081 => {
                  'URIEncoding' => 'UTF-8',
                  'connectionTimeout' => '20000',
                  'protocol' => 'HTTP/1.1',
                  'proxyName' => 'foo.example.com',
                  'proxyPort' => '8123',
                  'secure' => true,
                  'scheme' => 'https'
                },
                8082 => {
                  'URIEncoding' => 'UTF-8',
                  'connectionTimeout' => '20000',
                  'protocol' => 'HTTP/1.1',
                  'proxyName' => 'bar.example.com',
                  'proxyPort' => '8124',
                  'scheme' => 'http'
                }
              }
            }
          end

          it do
            is_expected.to contain_file('/opt/confluence/atlassian-confluence-5.5.6/conf/server.xml').
              with_content(%r{<Connector port="8081"}).
              with_content(%r{connectionTimeout="20000"}).
              with_content(%r{protocol="HTTP/1\.1"}).
              with_content(%r{proxyName="foo\.example\.com"}).
              with_content(%r{proxyPort="8123"}).
              with_content(%r{scheme="https"}).
              with_content(%r{secure="true"}).
              with_content(%r{URIEncoding="UTF-8"}).
              with_content(%r{<Connector port="8082"}).
              with_content(%r{connectionTimeout="20000"}).
              with_content(%r{protocol="HTTP/1\.1"}).
              with_content(%r{proxyName="bar\.example\.com"}).
              with_content(%r{proxyPort="8124"}).
              with_content(%r{scheme="http"}).
              with_content(%r{URIEncoding="UTF-8"})
          end
        end

        context 'catalina_opts set to a string' do
          let(:params) do
            {
              version: '6.12.0',
              javahome: '/opt/java',
              catalina_opts: '-Dconfluence.upgrade.recovery.file.enabled=false -Dconfluence.cluster.node.name=myhostname'
            }
          end

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_file('/opt/confluence/atlassian-confluence-6.12.0/bin/setenv.sh').
              with_content(%r{CATALINA_OPTS=\"-Dconfluence.upgrade.recovery.file.enabled=false -Dconfluence.cluster.node.name=myhostname \${CATALINA_OPTS}\"})
          end
        end

        context 'catalina_opts set to an array' do
          let(:params) do
            {
              version: '6.12.0',
              javahome: '/opt/java',
              catalina_opts: ['-Dconfluence.upgrade.recovery.file.enabled=false', '-Dconfluence.cluster.node.name=myhostname']
            }
          end

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_file('/opt/confluence/atlassian-confluence-6.12.0/bin/setenv.sh').
              with_content(%r{CATALINA_OPTS=\"-Dconfluence.upgrade.recovery.file.enabled=false \${CATALINA_OPTS}\"}).
              with_content(%r{CATALINA_OPTS=\"-Dconfluence.cluster.node.name=myhostname \${CATALINA_OPTS}\"})
          end
        end

        context 'default java 11 specific option' do
          let(:params) do
            {
              version: '7.12.0',
              javahome: '/opt/java'
            }
          end

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_file('/opt/confluence/atlassian-confluence-7.12.0/bin/setenv.sh').
              with_content(%r{CATALINA_OPTS=\"-XX:\+ExplicitGCInvokesConcurrent -XX:\+PrintGCDateStamps \${CATALINA_OPTS}\"})
          end
        end

        context 'default java 11 big instance option' do
          let(:params) do
            {
              version: '7.12.0',
              javahome: '/opt/java',
              big_instances_opts: true
            }
          end

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_file('/opt/confluence/atlassian-confluence-7.12.0/bin/setenv.sh').
              with_content(%r{CATALINA_OPTS=\"-XX:ReservedCodeCacheSize=384m \${CATALINA_OPTS}\"})
          end
        end

        context 'java 8 specific option' do
          let(:params) do
            {
              version: '7.12.0',
              javahome: '/opt/java',
              jvm_type: 'oracle-jdk-1.8'
            }
          end

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_file('/opt/confluence/atlassian-confluence-7.12.0/bin/setenv.sh').
              with_content(%r{CATALINA_OPTS=\"-XX:-PrintGCDetails -XX:\+PrintGCDateStamps -XX:-PrintTenuringDistribution \${CATALINA_OPTS}\"})
          end
        end

        context 'manage_user set to true' do
          let(:params) do
            {
              version: '6.12.0',
              javahome: '/opt/java',
              manage_user: true
            }
          end

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_user('confluence').that_notifies('Exec[chown_/opt/confluence/atlassian-confluence-6.12.0]')
          end
        end

        context 'manage_user set to false' do
          let(:params) do
            {
              version: '6.12.0',
              javahome: '/opt/java',
              manage_user: false
            }
          end

          it do
            is_expected.to compile.with_all_deps
            is_expected.not_to contain_user('confluence')
          end
        end
      end
    end
  end
end
