module EasyType
  module Generators
    class RegularTypeGenerator < EasyType::Generators::Base

      PROVIDER_TEMPLATE  = "regular_type.rb.erb"
      TYPE_TEMPLATE      = "regular_type_provider.rb.erb"


      def initialize(type_name, options)
        super(type_name, options)
        @provider    = options.fetch(:provider) {'default_provider'}
        @description = options.fetch(:description) {'A custom type'}
      end

      #
      # Run the scaffolder
      # It created the directories and the nescessary files
      #
      def run
        super
        create_type_source
        create_provider_source
      end

      protected

        #
        # Create the type source file.
        # ./lib/puppet/type/type_name.rb
        #
        def create_type_source
          create_source(TYPE_TEMPLATE, type_path)
        end

        #
        # Create the provider source file.
        # ./lib/puppet/provider/type_name/provider_name.rb
        #
        def create_provider_source
          create_source(PROVIDER_TEMPLATE, provider_path)
        end
    end
  end
end