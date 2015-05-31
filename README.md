# Tag Log

This report is a report processor that will send puppet events to syslog
filtered by a list of tags.

# Usage
The report processor is installed by placing this module in your modulepath.
It reads a configuration file "taglog.yaml" in your confdir that will have the following
format. 


/etc/puppetlabs/puppet/taglog.yaml
```yaml
---
  tags:
    - foo
    - bar
```

These tags will be the filter for the log messages in the report that are sent syslog.
You can configure these tags by using the included `taglog` class in this module

```puppet
class {'taglog':
  tags => ['foo','bar'],
}
```

To enable the puppet master you will need to add this report processor
to the masters configuration file.

```ini
reports = console,puppetdb,taglog
```
Note: The configuration file needs to be created prior to enabling the report
processor.

## Parsing information
The following regular expression should match the content of this example
```
^.*\((.*[^)])\) ([0-9]+-[0-9]+-[0-9]+) ([0-9]+:[0-9]+:[0-9]+) (-?[0-9]+) (\w+)
(\w+) (\w+) (.*) (\/.*\.pp:[0-9]+) (.*)$
```
Using this example message

```
May 31 00:21:44 aio-master-1 puppet-master[2421]: (agent-2.vm) 2015-05-31 00:21:44 -0700 notice production 1433056902 current_value ["AUTHPRIVX"], should be AUTHPRIV (noop) /etc/puppetlabs/puppet/manifests/site.pp:6 security,notice
```
It will split it into 10 match groups

1.  agent-2.vm
2.  2015-05-31
3.  00:21:44
4.  -0700
5.  notice
6.  production
7.  1433056902
8.  current_value ["AUTHPRIVX"], should be AUTHPRIV (noop)
9.  /etc/puppetlabs/puppet/manifests/site.pp:6
10. security,notice


Which corresponds to
1. certname
2. date
3. time
4. timezone
5. err,warning,info,notice
6. environment
7. config_version
8. log message
9. filepath:linenumber
10. list of the tags for that event, comma separated.

# Advanced usage
You can configure the syslog faciliy via the built-in puppet.conf configuration.
more information about this can be found here: [https://docs.puppetlabs.com/references/latest/configuration.html#syslogfacility](https://docs.puppetlabs.com/references/latest/configuration.html#syslogfacility)
