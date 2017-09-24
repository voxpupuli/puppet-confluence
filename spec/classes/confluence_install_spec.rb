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
              javahome: '/opt/java',
              version: '5.5.6',
              user: 'confluence',
              group: 'confluence',
              installdir: '/opt/confluence',
              homedir: '/home/confluence',
              format: 'tar.gz',
              product: 'confluence'
            }
          end

          it { is_expected.to compile.with_all_deps }

          it 'creates a system group' do
            is_expected.to contain_group('confluence').with_system(true)
          end

          it 'creates a system user with no shell' do
            is_expected.to contain_user('confluence').with('shell' => '/bin/true',
                                                           'system' => true)
          end

          it 'deploys confluence 5.5.6 from tar.gz' do
            is_expected.to contain_archive('/tmp/atlassian-confluence-5.5.6.tar.gz').
              with('extract_path'  => '/opt/confluence/atlassian-confluence-5.5.6',
                   'source'        => 'https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-5.5.6.tar.gz',
                   'creates'       => '/opt/confluence/atlassian-confluence-5.5.6/conf',
                   'user'          => 'confluence',
                   'group'         => 'confluence',
                   'checksum_type' => 'md5')
          end

          it 'manages the confluence home directory' do
            is_expected.to contain_file('/home/confluence').with('ensure' => 'directory',
                                                                 'owner' => 'confluence',
                                                                 'group' => 'confluence')
          end
        end

        context 'overwriting params' do
          let(:params) do
            {
              javahome: '/opt/java',
              version: '5.5.5',
              product: 'confluence',
              format: 'tar.gz',
              installdir: '/opt/foo/confluence',
              homedir: '/random/homedir',
              user: 'foo',
              group: 'bar',
              uid: 333,
              gid: 444,
              shell: '/bin/bash',
              download_url: 'http://downloads.atlassian.com'
            }
          end

          it do
            is_expected.to contain_user('foo').with('home' => '/random/homedir',
                                                    'shell' => '/bin/bash',
                                                    'uid'   => 333,
                                                    'gid'   => 444)
          end

          it { is_expected.to contain_group('bar') }

          it 'deploys confluence 5.5.5 from tar.gz' do
            is_expected.to contain_archive('/tmp/atlassian-confluence-5.5.5.tar.gz').
              with('extract_path'  => '/opt/foo/confluence/atlassian-confluence-5.5.5',
                   'source'        => 'http://downloads.atlassian.com/atlassian-confluence-5.5.5.tar.gz',
                   'creates'       => '/opt/foo/confluence/atlassian-confluence-5.5.5/conf',
                   'user'          => 'foo',
                   'group'         => 'bar',
                   'checksum_type' => 'md5')
          end
          it 'manages the confluence home directory' do
            is_expected.to contain_file('/random/homedir').with('ensure' => 'directory',
                                                                'owner' => 'foo',
                                                                'group' => 'bar')
          end
        end
      end
    end
  end
end
