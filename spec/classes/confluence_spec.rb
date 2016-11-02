require 'spec_helper.rb'

describe 'confluence' do
  context 'with javahome not set' do
    it('fails') do
      is_expected.to raise_error(Puppet::Error, %r{You need to specify a value for javahome})
    end
  end

  context 'with javahome set' do
    let(:params) do
      { javahome: '/foo/bar' }
    end
    it { is_expected.to contain_class('confluence') }
    it { is_expected.to contain_class('confluence::install') }
    it { is_expected.to contain_class('confluence::config') }
    it { is_expected.to contain_class('confluence::service') }
  end
end
