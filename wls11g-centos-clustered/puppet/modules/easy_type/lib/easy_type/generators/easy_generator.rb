module EasyType
  module Generators
    class EasyGenerator < EasyType::Generators::Base

      def run
        super
        create_type_attribute_directory
        create_type_shared_directory
      end

      protected
        #
        # Create the directory where all easy_type parameters and property
        # files reside. This is probably only called when creating an easy_type
        #
        def create_type_attribute_directory
          create_directory type_attribute_directory
        end

        #
        # Create the directory where all the easy_type shared parameters reside.
        # This is probably only called when creating an easy_type
        #
        def create_type_shared_directory
          create_directory type_shared_directory
        end
    end
  end
end