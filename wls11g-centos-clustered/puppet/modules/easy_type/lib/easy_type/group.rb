# encoding: UTF-8
module EasyType
  #
  # A [Group] is a definition of a set of [Parameter] and/or [Property]
  # classes. When you add a [Property] or a [Parameter] to a [Group], you
  # specify that whenever one of the properties is changed, all the `on_modify`
  # methods of all parameters and properties are called.
  #
  # This is a mechanism to ensure an `on_update` or `on_create` always is
  # syntacticaly correct and has all the information needed.
  #
  class Group
    # @private
    def initialize
      @content = {}
    end

    #
    # Get all parameters and properties from the specified group name. If the
    # group doesn't exist raise an exception
    #
    # @param group_name [String] this is the name of the group.
    # @return [Array] an Array of parameters and properties
    # @raise [Puppet::Error] When the group doesn't exist
    #
    def contents_for(group_name)
      @content.fetch(group_name) do
        fail "easy_type: No group defined with name #{group_name}"
      end
    end

    #
    # Add a parameter or a propert to a group. The may or may not exists.
    # If it doesn't exist, it will be created. The name of a group is just for
    # identification purpose's. It doesn't have any other meaning.
    #
    # @param group_name [String] this is the name of the group.
    # @param parameter_or_property [Puppet::Parameter] this is the specified
    #        parameter.
    # @return [Group] the group
    # @raise [Puppet::Error] When the group doesn't exist
    #
    def add(group_name, parameter_or_property)
      group = ensure_group(group_name)
      group << parameter_or_property
      group
    end

    #
    # returns the group name for a given parameter or property. If the group
    # doesn't exist, it will raise an error
    #
    # @param parameter_or_property [Puppet::Parameter] this is the specified
    #        parameter.
    # @return [Symbol] the group name
    # @raise [Puppet::Error] When the group doesn't exist
    #
    def group_for(parameter_or_property)
      @content.each_pair do | key, value|
        return key if value.include?(parameter_or_property)
      end
      fail "easy_type: #{parameter_or_property} not found in any group"
    end

    #
    # Returns true if the group exists
    #
    # @param group_name [String] this is the name of the group.
    # @return [Boolean] true if the group exists. False if the group doesn't
    #          exist.
    #
    def include?(group_name)
      @content.keys.include?(group_name)
    end

    #
    # Returns true if the paremeter or property is included in any
    # existing group
    #
    # @param parameter_or_property [Puppet::Parameter] this is the specified
    #        parameter.
    # @return [Boolean]
    #
    def include_property?(parameter_or_property)
      @content.values.flatten.include?(parameter_or_property)
    end

    private

    # @private
    def ensure_group(group_name)
      @content.fetch(group_name) { @content[group_name] = [] }
    end
  end
end
