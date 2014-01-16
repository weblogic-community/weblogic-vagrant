Puppet::Type.newtype(:sysctl) do

  @doc = <<-EOS
    This type provides the capability to manage sysctl kernel parameters within
    puppet.
  EOS

  ensurable
  newparam(:name, :namevar => true) do
    desc "the name of the kernel parameter to fiddle with"
  end

  newproperty(:value) do
    desc "the value that the running kernel should be set to"
  end

  newproperty(:permanent) do
    desc "whether the value should be in [/etc/sysctl.conf]"
    defaultto 'no'
    newvalues (/yes|no/)
  end

  newparam(:path) do
    desc "which sysctl.conf we are dealing with"
    defaultto '/etc/sysctl.conf'
    validate do |value|
      unless value =~ /^\/\S+/
        raise ArgumentError, "Path is not a fully qualified path: #{value}" 
      end
    end
  end

end
