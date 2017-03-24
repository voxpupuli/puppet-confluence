Facter.add(:confluence_version) do
  setcode do
    ps = Facter::Util::Resolution.exec('ps ax')
    confluence_process = ps && ps.split("\n").find { |x| x.include?('atlassian-confluence-') }
    confluence_process =~ %r{^.*atlassian-confluence-(\d+\.\d+\.\d+).*}
    if Regexp.last_match(1).nil?
      'unknown'
    else
      Regexp.last_match(1)
    end
  end
end
