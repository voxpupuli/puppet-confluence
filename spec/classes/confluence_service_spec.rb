require 'spec_helper.rb'

describe 'confluence' do
  describe 'confluence::config' do
    context 'default params' do
      let(:params) {{
        :javahome => '/opt/java',
        :version  => '5.5.6',
      }}
      it { should contain_service('confluence')}
    end
  end
end
