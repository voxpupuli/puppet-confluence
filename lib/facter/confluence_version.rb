Facter.add(:confluence_version) do
  setcode do
    pgrep = Facter::Util::Resolution.exec(
      'ps ax | grep java.*atlassian-confluence-[0-9].*org.apache.catalina.startup.Bootstrap'
    )
    pgrep.to_s =~ %r{^.*atlassian-confluence-(\d+\.\d+\.\d+).*}
    if Regexp.last_match(1).nil?
      'unknown'
    else
      Regexp.last_match(1)
    end
  end
end
