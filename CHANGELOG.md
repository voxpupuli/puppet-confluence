##2016-02-04 - Release 2.2.0

  - Deprecate the downloadURL parameter
  - Add a systemd unit file for the RHEL 7 family
  - Use a service_file_template variable to reference init scripts
  - Add a context_path parameter to manage situations where Confluence is
    served from a sub-path to the base URL
  - Add manage_user parameter
  - Fix minimum required stdlib version

##2014-03-22 - Release 2.1.1

  - Rewrite README file
  - Bump confluence version to 5.7.1
  - Update metadata, CHANGELOG to point to new namespace.
  - Add .pmtignore file

##2014-03-22 - Release 2.1.0

Note: This is the final release of this module before it is deprecated with a 999.999.999 version. This module will be moving the the puppet-community namespace on github and the puppet namespace on puppetforge soon.

  - Make confluence users shell configurable.
  - update README, metadata, .travis.yml
  - Add CONTRIBUTING.md and test coverage spec.

##2014-01-23 - Release 2.0.1
  - Resolve issue #22 - confluence_version fact detects wrong version
  - Resolve issue #20 - param manage_server_xml acceptCount option is duplicated

##2014-01-21 - Release 2.0.0
- Replace mkrakowitzer-deploy with nanlui-staging as default for dropping files.
  - Add tests
- Resolve issue #7 Make tomcat port / tomcat parameters configurable.
- Add parameter manage_server_xml, tomcat_max_threads, tomcat_accept_count, tomcat_extras.
  - Add tests
- rename parameter proxy to tomcat_proxy, port to tomcat_port.
- Add support for STRICT_VARIABLES=yes FUTURE_PARSER=yes
- Resole issue #6 Handle confluence upgrades smoothly
  - This will stop confluence if running version is less than manifest version. Attempt to upgrade and then start confluence.
