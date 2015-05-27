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

# Advanced usage
You can configure the syslog faciliy via the built-in puppet.conf configuration.
more information about this can be found here: [https://docs.puppetlabs.com/references/latest/configuration.html#syslogfacility](https://docs.puppetlabs.com/references/latest/configuration.html#syslogfacility)
