require 'spec_helper.rb'

describe 'confluence' do
  describe 'confluence::install' do
    context 'default params' do
      let(:params) do
        { :javahome => '/opt/java' }
      end
      let(:facts) do
        { :confluence_version => '1.5.4' }
      end
      it { should contain_exec('service confluence stop && sleep 15') }
    end
    context 'custom params' do
      let(:params) do
        {
          :javahome        => '/opt/java',
          :stop_confluence => 'stop service please'
        }
      end
      let(:facts) do
        { :confluence_version => '2.3.4a' }
      end
      it { should contain_exec('stop service please') }
    end
  end
end
