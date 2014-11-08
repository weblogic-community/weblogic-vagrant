require 'puppet/face'
require 'easy_type/generators/base'

Puppet::Face.define(:type, '0.0.1') do

  action(:scaffold) do
   default

    option "--provider NAME", "-p NAME" do
      summary "Name of the provider to create. "
      description <<-EOT
        Name of the provider to create.
      EOT
    end

    option "--description DESC", "-d DESC" do
      summary "Description of custom type."
      description <<-EOT
        A description of the custom type you are creating.
      EOT
    end

    option "--namevar VAR", "-n VAR" do
      summary "Name variable to use. Default is name"
      description <<-EOT
        Name variable to use. Default is name. This means the type will have a namevar
        named with the specified name.
      EOT
    end

   summary "Create a scaffold for custom types and providers"

    description <<-EOT
      Create the correct directories and files for a custom type and
      a custom provider.
    EOT

    examples <<-'EOT'
      To create a scaffold for a new custom easy type, enter:

      $ puppet type scaffold easy_type type_name

      This creates the following files:
        - lib/puppet/type/type_name.rb
        - lib/puppet/type/type_name/name.rb
        - lib/puppet/provider/type_name/simple.rb

    EOT

    arguments "<scaffold_type> <custom_type_name>"

    when_invoked do | scaffold_name, name, options |
      Object.send(:remove_const, :GeneratorClass) if defined?(GeneratorClass)# Just to remove any warnings
      GeneratorClass = EasyType::Generators::Base.load( scaffold_name)
      generator = GeneratorClass.new(name, options)
      generator.run
      nil
    end
  end

end

