require 'spec_helper.rb'

describe 'confluence' do
  context 'with javahome not set' do
    it('should fail') {
      should raise_error(Puppet::Error, /You need to specify a value for javahome/)
    }
  end

  context 'with javahome set' do
    let(:params) do
      { :javahome => '/foo/bar' }
    end
    it { should contain_class('confluence') }
    it { should contain_class('confluence::install') }
    it { should contain_class('confluence::config') }
    it { should contain_class('confluence::service') }
  end
end
