puppet-confluence
=================
[![Build
Status](https://travis-ci.org/mkrakowitzer/puppet-confluence.svg)](https://travis-ci.org/mkrakowitzer/puppet-confluence)

This is a puppet module to install Atlassian Confluence

Requirements
------------
* Puppet 3.0+ tested 
* Puppet 2.7+
* dependency 'mkrakowitzer/deploy', '>= 0.0.1'

Example
-------
```puppet
  class { 'confluence':
    javahome       => '/opt/java',
  }
```

Customization
-------------
This module also allows for direct customization of the JVM, following [atlassians recommendations](https://confluence.atlassian.com/display/JIRA/Setting+Properties+and+Options+on+Startup)

This is especially useful for setting properties such as http/https proxy settings.
Support has also been added for reverse proxying stash via apache or nginx.

```puppet
  class { 'confluence':
    version        => '5.5.5',
    installdir     => '/opt/atlassian/atlassian-confluence',
    homedir        => '/opt/atlassian/application-data/confluence-home',
    javahome       => '/opt/java',
    jvm_support_recommended_args => '-Dhttp.proxyHost=proxy.example.com -Dhttp.proxyPort=3128 -Dhttps.proxyHost=secure-proxy.example.com -Dhttps.proxyPort=3128'
    proxy          => {
      scheme       => 'https',
      proxyName    => 'confluence.example.co.za',
      proxyPort    => '443',
    },
  }
```

A complete example of running confluence with puppet is available at [vagrant-puppet-confluence](http://github.com/mkrakowitzer/vagrant-puppet-confluence)

Paramaters
----------
####`javahome`
Specify the java home directory. No assumptions are made re the location of java and therefor this option is required. Default: undef
####`jvm_xms`
The initial memory allocation pool for a Java Virtual Machine. Default: '256m'
####`jvm_xmx`
Maximum memory allocation pool for a Java Virtual Machine. Default: '1024m'
####`jvm_permgen`
Increase max permgen size for a Java Virtual Machine. Default: '256m'
####`java_opts`
Additional java options can be specified here. Default: ''
####`version`
The version of confluence to install. Default: '5.5.6'
####`format`
The format of the file confluence will be installed from. Default: 'tar.gz'
####`installdir`
The installation directory of the confluence binaries. Default: '/opt/confluence'
####`homedir`
The home directory of confluence. Configuration files are stored here. Default: '/home/confluence'
####`user`
The user that confluence should run as, as well as the ownership of confluence related files. Default: 'confluence'
####`group`
The group that confluence files should be owned by. Default: 'confluence'
####`uid`
Specify a uid of the stash user. Default: undef
####`gid`
Specify a gid of the stash user. Default: undef
####`downloadURL`
Default: 'http://www.atlassian.com/software/confluence/downloads/binary/'
####`manage_service`
Should puppet manage this service? Default: true
####`proxy`
Reverse https proxy configuration. See customization section for more detail. Default: {}

Testing
-------
Using [puppetlabs_spec_helper](https://github.com/puppetlabs/puppetlabs_spec_helper). Simply run:

```
bundle install && bundle exec rake spec
```

to get results.

```
ruby-1.9.3-p484/bin/ruby -S rspec spec/classes/stash_install_spec.rb --color
.

Finished in 0.38159 seconds
1 example, 0 failures
```
License
-------
The MIT License (MIT)

Contributors
------------
* Merritt Krakowitzer merritt@krakowitzer.com
* Bruce Morrison

Support
-------

Please log tickets and issues at our [Projects site](http://github.com/mkrakowitzer/puppet-confluence)
