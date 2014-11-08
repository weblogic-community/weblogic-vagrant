require 'easy_type/generators/easy_generator'

module EasyType
  module Generators
    class EasyAttributeGenerator < EasyType::Generators::EasyGenerator

      ATTRIBUTE_TEMPLATE  = "easy_type_attribute.rb.erb"
      END_PARAMETER_BLOCK = /(^.*-- end of attributes --.*$)/
      END_PARAMETER_TEXT  = "    # -- end of attributes -- Leave this comment if you want to use the scaffolder
"

      def initialize(attribute_name, type_name, options)
        super(type_name, options)
        @attribute_name   = attribute_name
        @attribute_type   = options.fetch(:attribute_type) {:parameter}
        @description      = options.fetch(:description) {'A generated attribute'}
        @parameter_key    = options.fetch(:key) {@attribute_name}
        @shared           = options.has_key?(:shared)
      end

      #
      # Run the scaffolder
      # It created the directories and the nescessary files
      #
      def run
        super
        create_easy_attribute_source
        add_attribute_to_type
      end

      protected
        #
        # Create the easy type name attribute source file.
        # ./lib/puppet/type/type_name/attribute_name.rb
        #
        def create_easy_attribute_source
          path = @shared ? shared_attribute_path : attribute_path
          create_source(ATTRIBUTE_TEMPLATE, path)
        end

        #
        # Add the attribute to the type source
        #
        def add_attribute_to_type
          check_type_exists
          type_content = File.read(type_path)
          unless parameter_in_type?(type_content)
            type_content.sub!(END_PARAMETER_BLOCK,"\t\t#{@attribute_type} :#{@attribute_name}\n#{END_PARAMETER_TEXT}")
            save_file(type_path, type_content)
            Puppet.notice "#{@attribute_type.capitalize} #{@attribute_name} added to #{type_path}"
          else
            Puppet.notice "#{@attribute_type.capitalize} #{@attribute_name} already in #{type_path}"
          end
        end

        def check_type_exists
          fail "Type file #{type_path} doesn't exist." unless File.exists?(type_path)
        end

        def parameter_in_type?(content)
          search_string = "^\\s*#{@attribute_type}\\s*:#{@attribute_name}.*$"
          regexp = Regexp.new search_string
          not content.scan(regexp).empty?
        end
    end
  end
end