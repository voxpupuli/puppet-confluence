Facter.add(:confluence_version) do
  setcode do
    ps = Facter::Util::Resolution.exec('ps ax')
    confluence_process = ps && ps.split("\n").find { |x| x.include?('atlassian-confluence') }
    if confluence_process.nil?
      'unknown'
    else
      confluence_process.scan(%r{atlassian-confluence-(\d+\.\d+\.\d+)}).first.first
    end
  end
end
