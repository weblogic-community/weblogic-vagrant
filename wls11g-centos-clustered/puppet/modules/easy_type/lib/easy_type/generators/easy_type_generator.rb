require 'easy_type/generators/easy_generator'

module EasyType
  module Generators
    class EasyTypeGenerator < EasyType::Generators::EasyGenerator

      PROVIDER_TEMPLATE  = "easy_type_provider.rb.erb"
      TYPE_TEMPLATE      = "easy_type.rb.erb"
      PARAMETER_TEMPLATE = "easy_type_name_attribute.rb.erb"

      def initialize(type_name, options)
        super(type_name, options)
        @provider    = options.fetch(:provider) {'default_provider'}
        @description = options.fetch(:description) {'A custom type'}
        @namevar     = options.fetch(:namevar) {'name'}
      end

      #
      # Run the scaffolder
      # It created the directories and the nescessary files
      #
      def run
        super
        create_easy_type_source
        create_simple_provider_source
        create_name_attribute_source
      end

        #
        # Create the easy type source file.
        # ./lib/puppet/type/type_name.rb
        #
        def create_easy_type_source
          create_source(TYPE_TEMPLATE, type_path)
        end

        #
        # Create the easy_type provider source file.
        # ./lib/puppet/provider/type_name/provider_name.rb
        #
        def create_simple_provider_source
          create_source(PROVIDER_TEMPLATE, provider_path)
        end

        #
        # Create the easy type name attribute source file.
        # ./lib/puppet/type/type_name/parameter_name.rb
        #
        def create_name_attribute_source
          create_source(PARAMETER_TEMPLATE, name_attribute_path)
        end

    end
  end
end