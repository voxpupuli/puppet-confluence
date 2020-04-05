require 'spec_helper'
require 'facter/confluence_version'

describe Facter::Util::Fact do
  subject { Facter.fact(:confluence_version).value }

  before do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
    allow(Facter::Util::Resolution).to receive(:exec).with('ps ax | grep java.*atlassian-confluence-[0-9].*org.apache.catalina.startup.Bootstrap').and_return(proc_line_result)
  end

  context 'confluence_version with confluence running' do
    let(:proc_line_result) do
      '27999 ?        Sl     4:10 /usr//bin/java -Djava.util.logging.config.file=/opt/confluence/atlassian-confluence-5.7.1/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Xms256m -Xmx1024m -XX:MaxPermSize=256m -Djava.awt.headless=true -Djava.endorsed.dirs=/opt/confluence/atlassian-confluence-5.7.1/endorsed -classpath /opt/confluence/atlassian-confluence-5.7.1/bin/bootstrap.jar:/opt/confluence/atlassian-confluence-5.7.1/bin/tomcat-juli.jar -Dcatalina.base=/opt/confluence/atlassian-confluence-5.7.1 -Dcatalina.home=/opt/confluence/atlassian-confluence-5.7.1 -Djava.io.tmpdir=/opt/confluence/atlassian-confluence-5.7.1/temp org.apache.catalina.startup.Bootstrap start'
    end

    it 'returns the running version' do
      is_expected.to eq('5.7.1')
    end
  end

  context 'confluence_version with confluence running non-standard java' do
    let(:proc_line_result) do
      '27999 ?        Sl     4:10 /usr/lib/jvm/java-1.8.0-oracle/bin/java -Djava.util.logging.config.file=/opt/confluence/atlassian-confluence-5.7.1/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Xms256m -Xmx1024m -XX:MaxPermSize=256m -Djava.awt.headless=true -Djava.endorsed.dirs=/opt/confluence/atlassian-confluence-5.7.1/endorsed -classpath /opt/confluence/atlassian-confluence-5.7.1/bin/bootstrap.jar:/opt/confluence/atlassian-confluence-5.7.1/bin/tomcat-juli.jar -Dcatalina.base=/opt/confluence/atlassian-confluence-5.7.1 -Dcatalina.home=/opt/confluence/atlassian-confluence-5.7.1 -Djava.io.tmpdir=/opt/confluence/atlassian-confluence-5.7.1/temp org.apache.catalina.startup.Bootstrap start'
    end

    it 'returns the running version' do
      is_expected.to eq('5.7.1')
    end
  end

  context 'confluence_version with confulence not running' do
    let(:proc_line_result) { '' }

    it 'returns "unknown"' do
      is_expected.to eq('unknown')
    end
  end
end
