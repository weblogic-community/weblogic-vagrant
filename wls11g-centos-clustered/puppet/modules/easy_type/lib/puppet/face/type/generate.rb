require 'puppet/face'
require 'easy_type/generators/base'

Puppet::Face.define(:type, '0.0.1') do

  action(:generate) do

    option "--shared", "-s" do
      summary "Create a shared property or parameter"
      description <<-EOT
        Easy type supports shared parameters and properties. These are parameters that can be used
        by more then one type. If you want your parameter or property to be shared, use This
        option.
      EOT
    end

    option "--description DESC", "-d DESC" do
      summary "Description of property or parameter"
      description <<-EOT
        A description of the parameter or property you are creating.
      EOT
    end

    option "--key NAME", "-k NAME" do
      summary "key to use when parsing the data."
      description <<-EOT
        Easy type uses a key to parse returned data and get the value for an attribute.
        The default value the generator uses is the name of the property or parameter.
        Using this option you can specify a specific key
      EOT
    end

    summary "Create a parameter or property for a easy_type custom type"

    description <<-EOT
      Create a parameter or a property for an easy_type custom type. Also
      add the property to the defined type.
    EOT

    examples <<-'EOT'
      To create a parameter for a custom easy type, enter:

      $ puppet type generate parameter parameter_name type_name

      This creates the following file:
        - lib/puppet/type/type_name/parameter_name.rb

      It also modifies:
        - lib/puppet/type/type_name.rb

      To create a property for a custom easy type, enter:

      $ puppet type generate property property_name type_name

      This creates the following file:
        - lib/puppet/type/type_name/property_name.rb

      It also modifies:
        - lib/puppet/type/type_name.rb

    EOT

    arguments "<attribute_type> <attribute_name> <type_name>"

    when_invoked do | attribute_type, attribute_name, type_name, options |
      Puppet.error "invalid attribute type"  if not ['parameter','property'].include?(attribute_type)
      options[:attribute_type] = attribute_type
      Object.send(:remove_const, :GeneratorClass) if defined?(GeneratorClass)# Just to remove any warnings
      GeneratorClass = EasyType::Generators::Base.load('easy_attribute')
      generator = GeneratorClass.new(attribute_name, type_name, options)
      generator.run
      nil
    end
  end

end

