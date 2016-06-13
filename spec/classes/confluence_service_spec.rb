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
      it { should contain_service('confluence') }
    end
  end
end
