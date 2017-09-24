require 'spec_helper.rb'

describe 'confluence' do
  on_supported_os.each do |os, fs_facts|
    context "on #{os}" do
      let :facts do
        fs_facts
      end

      context 'with javahome not set' do
        it('fails') do
          is_expected.to raise_error(Puppet::Error, %r{You need to specify a value for javahome})
        end
      end

      context 'with javahome set' do
        let(:params) do
          { javahome: '/foo/bar' }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('confluence') }
        it { is_expected.to contain_class('confluence::install') }
        it { is_expected.to contain_class('confluence::config') }
        it { is_expected.to contain_class('confluence::service') }
      end
    end
  end
end
