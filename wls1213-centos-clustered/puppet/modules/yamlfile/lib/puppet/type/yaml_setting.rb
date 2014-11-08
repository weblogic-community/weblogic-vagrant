Puppet::Type.newtype(:yaml_setting) do
  @doc = "Manage settings in yaml configuration files"
  desc <<-EOT
    Ensures that a given yaml hash key and value exists within a yaml file.
    Nested hash keys can be specified by a key-delimited string. Existing
    data in the target yaml file will be preserved. No guarantees about
    comments or other formatting/non-functional details.

    Example:

      yaml_setting { 'simple_example':
        target => '/etc/example.yaml',
        key    => 'greeting',
        value  => 'hello',
      }

      yaml_setting { 'nested_key_example1':
        target  => '/etc/example.yaml',
        key     => 'database/username',
        value   => 'console',
      }

      yaml_setting { 'nested_key_example2':
        target  => '/etc/example.yaml',
        key     => 'database/password',
        value   => 'passw0rd',
      }

      yaml_setting { 'nested_key_example3':
        target  => '/etc/example.yaml',
        key     => 'one/two/three',
        type    => 'array',
        value   => [ 'a', 'b', 'c' ],
      }

    Result (/etc/example.yaml):

      --- 
        greeting: hello
        database: 
          username: console
          password: passw0rd
        one: 
          two: 
            three: 
              - a
              - b
              - c

    In this example, several yaml_settings were specified and the resulting
    merged hash was created in /etc/example.yaml. If /etc/example.yaml had
    already contained data, any keys not specified in a yaml_setting resource
    would be preserved.

  EOT

  ensurable

  newproperty(:target) do
    desc "The configuration file in which to place settings"
    isrequired
    isnamevar
  end

  newproperty(:key) do
    desc "The yaml key"
    isrequired
    isnamevar
  end

  newparam(:nodisplay) do
    desc "Set to true for values such as passwords to obfuscate log output"
    defaultto false
  end

  newproperty(:type) do
    desc "The data type"
    # There is no default for this value. The validation routine of the "value"
    # property will set one automatically if the user did not supply one. It is
    # necessary to do it this way because until the value property is parsed,
    # we don't know what kind of data the user supplied.
  end

  newproperty(:value, :array_matching => :all) do
    desc "The value to give the configuration key"

    munge do |value|
      if @resource[:type]
        case @resource[:type].to_sym
        when :integer
          value.to_i
        when :float
          value.to_f
        else
          value
        end
      else
        value
      end
    end

    validate do |val|
      case @resource[:type]
      when nil
        if @shouldorig.is_a?(Array) and @shouldorig.size > 1
          @resource[:type] = 'array'
        else
          case val.class.to_s.downcase.to_sym
          when :trueclass, :falseclass
            @resource[:type] = 'boolean'
          else
            @resource[:type] = 'string'
          end
        end
      when 'hash', 'array'
        # we're just leaving these values alone
      else
        if @shouldorig.is_a?(Array) and @shouldorig.size > 1
          raise "Array provided, but type specified as #{@resource[:type]}."
        end
      end
    end

    def should_to_s(new_value=@should)
      display = if @resource[:type] == 'symbol'
        val.first.to_sym.inspect
      elsif @resource[:type] != 'array' and new_value.is_a?(Array)
        new_value.join(' ')
      else
        new_value.first.inspect
      end
      @resource[:nodisplay] ? "[new value redacted]" : display
    end

    def is_to_s(current_value=@is)
      display = if current_value.is_a?(Array) and current_value.size > 1
        current_value
      else
        current_value.join(' ')
      end
      @resource[:nodisplay] ? "[old value redacted]" : display
    end

    def insync?(is)
      # can't munge value to symbol so must do it here:
      if @resource[:type] == 'symbol'
        should.first.to_sym == is.first
      else
        super(is)
      end
    end
  end

  newparam(:name) do
    desc "The name"
    munge do |discard|
      target = @resource.original_parameters[:target]
      key    = @resource.original_parameters[:key]
      "#{target.to_s}:#{key.to_s}"
    end
  end


  # Our title_patterns method for mapping titles to namevars for supporting
  # composite namevars.
  def self.title_patterns
    identity = lambda {|x| x}
    [
      [
        /^([^:]+)$/,
        [
          [ :name, identity ]
        ]
      ],
      [
        /^((.*):(.*))$/,
        [
          [ :name, identity ],
          [ :key, identity ],
          [ :value, identity ]
        ]
      ]
    ]
  end

  autorequire :file do
    self[:target]
  end
end
