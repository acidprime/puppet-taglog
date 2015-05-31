require 'puppet/reports'
require 'yaml'

Puppet::Reports.register_report(:taglog) do
  desc "Send all matching taged logs to the local syslog"

  configfile = File.join(Puppet.settings[:confdir], 'taglog.yaml')
  raise(Puppet::ParseError, "Taglog report config file #{configfile} not readable") unless File.exist?(configfile)
  CONFIG = YAML.load_file(configfile)

  # Find all matching messages.
  def match(tags)
    messages = self.logs.find_all do |log|
      tags.detect { |tag| log.tagged?(tag) }
    end

    if messages.empty?
      Puppet.info "No messages match tags #{tags}"
      next
    end
    messages 
  end

  def process
    metrics = raw_summary['resources'] || {} rescue {}

    if metrics['out_of_sync'] == 0 && metrics['changed'] == 0
      Puppet.notice "Not sending to syslog; no changes"
      return
    end

    # Filter based on tags and shows tags in line
    filtered = match(CONFIG['tags'])
    filtered.each do |log|
      log.source = "#{self.host}"
      Puppet::Util::Log.with_destination(:syslog) do
        message = [
          log.time,
          log.level.to_s,
          self.environment,
          self.configuration_version,
          log.message,
          "#{log.file}:#{log.line}",
          log.tags.join(',')
        ]
        log.message = message.join(' ')
        Puppet::Util::Log.newmessage(log)
      end
    end
  end
end

