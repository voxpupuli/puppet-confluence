require 'spec_helper.rb'
describe 'confluence' do
  describe 'confluence::facts' do
    let(:params) do
      { javahome: '/opt/java' }
    end
    pe_external_fact_file = '/etc/puppetlabs/facter/facts.d/confluence_facts.sh'
    external_fact_file = '/etc/facter/facts.d/confluence_facts.sh'

    it { is_expected.to contain_file(external_fact_file) }

    # Test puppet enterprise shebang generated correctly
    context 'with puppet enterprise' do
      let(:facts) do
        { puppetversion: '3.4.3 (Puppet Enterprise 3.2.1)' }
      end
      it do
        is_expected.to contain_file(pe_external_fact_file) \
      end
    end
  end
end
