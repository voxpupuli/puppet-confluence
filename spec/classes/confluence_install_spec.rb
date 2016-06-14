require 'spec_helper.rb'

describe 'confluence' do
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

      it { should contain_group('confluence') }

      it { should contain_user('confluence').with_shell('/bin/true') }

      it 'deploys confluence 5.5.6 from tar.gz' do
        should contain_archive('/tmp/atlassian-confluence-5.5.6.tar.gz').
          with('extract_path' => '/opt/confluence/atlassian-confluence-5.5.6',
               'source'        => 'http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-5.5.6.tar.gz',
               'creates'       => '/opt/confluence/atlassian-confluence-5.5.6/conf',
               'user'          => 'confluence',
               'group'         => 'confluence',
               'checksum_type' => 'md5')
      end

      it 'manages the confluence home directory' do
        should contain_file('/home/confluence').with('ensure' => 'directory',
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
        should contain_user('foo').with('home' => '/random/homedir',
                                        'shell' => '/bin/bash',
                                        'uid'   => 333,
                                        'gid'   => 444)
      end

      it { should contain_group('bar') }

      it 'deploys confluence 5.5.5 from tar.gz' do
        should contain_archive('/tmp/atlassian-confluence-5.5.5.tar.gz').
          with('extract_path' => '/opt/foo/confluence/atlassian-confluence-5.5.5',
               'source'        => 'http://downloads.atlassian.com/atlassian-confluence-5.5.5.tar.gz',
               'creates'       => '/opt/foo/confluence/atlassian-confluence-5.5.5/conf',
               'user'          => 'foo',
               'group'         => 'bar',
               'checksum_type' => 'md5')
      end
      it 'manages the confluence home directory' do
        should contain_file('/random/homedir').with('ensure' => 'directory',
                                                    'owner' => 'foo',
                                                    'group' => 'bar')
      end
    end
  end
end
