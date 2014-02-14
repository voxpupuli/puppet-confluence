puppet-confluence
=================

This is a puppet module to install confluence

Requirements
------------
* Puppet 3.0+ tested 
* Puppet 2.7+
* dependency 'mkrakowitzer/deploy', '>= 0.0.1'


Example
-------
```puppet
  class { 'confluence':
    version        => '5.4.1',
    installdir     => '/opt/atlassian/atlassian-confluence',
    homedir        => '/opt/atlassian/application-data/confluence-home',
    javahome       => '/opt/java',
  }
```
Paramaters
----------
TODO

License
-------
The MIT License (MIT)

Contact
-------
Merritt Krakowitzer merritt@krakowitzer.com

Support
-------

Please log tickets and issues at our [Projects site](http://github.com/mkrakowitzer/puppet-confluence)
