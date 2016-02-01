require 'spec_helper.rb'

describe 'confluence' do
  describe 'confluence::install' do
    context 'default params' do
      let(:params) {{
        :javahome          => '/opt/java',
        :version           => '5.5.6',
        :user              => 'confluence',
        :group             => 'confluence',
        :installdir        => '/opt/confluence',
        :homedir           => '/home/confluence',
        :format            => 'tar.gz',
        :product           => 'confluence',
        :download_url      => 'http://www.atlassian.com/software/confluence/downloads/binary/',
	:staging_or_deploy => 'deploy',
        }}
      it { should contain_group('confluence') }
      it { should contain_user('confluence').with_shell('/bin/true') }
      it 'should deploy confluence 5.5.6 from tar.gz' do
        should contain_deploy__file("atlassian-confluence-5.5.6.tar.gz")
      end
      it 'should manage the confluence home directory' do
        should contain_file('/home/confluence').with({
          'ensure' => 'directory',
          'owner' => 'confluence',
          'group' => 'confluence'
          })
      end
    end
  
    context 'overwriting params' do
      let(:params) {{
        :javahome          => '/opt/java',
        :version           => '5.5.5',
        :product           => 'confluence',
        :format            => 'tar.gz',
        :installdir        => '/opt/confluence',
        :homedir           => '/random/homedir',
        :user              => 'foo',
        :group             => 'bar',
        :uid               => 333,
        :gid               => 444,
        :shell             => '/bin/bash',
        :download_url      => 'http://downloads.atlassian.com/',
        :staging_or_deploy => 'deploy',
      }}
      it { should contain_user('foo').with({
        'home'  => '/random/homedir',
        'shell' => '/bin/bash',
        'uid'   => 333,
        'gid'   => 444
      }) }
      it { should contain_group('bar') }
  
      it 'should deploy confluence 5.5.5 from tar.gz' do
        should contain_deploy__file("atlassian-confluence-5.5.5.tar.gz").with({
          'url' => 'http://downloads.atlassian.com/',
          'owner' => 'foo',
          'group' => 'bar'
        })
      end
  
      it 'should manage the confluence home directory' do
        should contain_file('/random/homedir').with({
          'ensure' => 'directory',
          'owner' => 'foo',
          'group' => 'bar'
        })
      end

    end
    context 'not managing user' do
        let(:params) {{
            :manage_user => false,
            :javahome    => '/foo/bar',
        }}
        it {
            should_not contain_user('confluence')
        }
        it {
            should_not contain_group('confluence')
        }
    end
  end
end
