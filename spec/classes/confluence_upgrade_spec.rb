require 'spec_helper.rb'

describe 'confluence' do
  describe 'confluence::install' do
    context 'default params' do
      let(:params) {{
        :javahome    => '/opt/java',
      }}
      let(:facts) { {
        :confluence_version  => '1.5.4',
      }}
      it { should contain_exec('service confluence stop && sleep 15') }
    end
    context 'custom params' do
      let(:params) {{
        :javahome    => '/opt/java',
        :stop_confluence   => 'stop service please'
      }}
      let(:facts) { {
        :confluence_version  => '2.3.4a',
      }}
      it { should contain_exec('stop service please') }
    end

  end
end
