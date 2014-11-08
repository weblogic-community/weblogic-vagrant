# encoding: UTF-8
module EasyType
  #
  # This module contains all extensions for the Parameter class used by EasyType
  # To use it, include the following statement in your parameter of property block
  #
  #   include EasyType::Parameter
  #
  #
  module Parameter
    # @private
    def self.included(parent)
      parent.extend(ClassMethods)
    end

    # @private
    module ClassMethods
      #
      # retuns the string needed to modify this specific property of a defined type
      #
      # @example
      #
      #  newproperty(:password) do
      #    on_apply do
      #      "identified by #{resource[:password]}"
      #    end
      #  end
      #
      # @param [Method] block The code to be run on creating or modifying a resource. Although the code
      #                 customary returns just a string that is appended to the command, it can do
      #                 anything that is deemed nesceccary.
      #
      # @see on_create  For information on creating a resource
      # @see on_modify  For information on modifying an existing resource
      #
      def on_apply(&block)
        fail_if_competing_method_defined
        define_method(:on_apply, &block) if block
      end

      # @nodoc
      def fail_if_competing_method_defined
        ['on_create','on_modify', 'on_destroy'].each do | method_name |
          fail "method #{method_name} can not coexist with on_apply. Use one or the other" if called_before(method_name)
        end
      end

      def called_before(method_name)
        self.method_defined? method_name
      end

      #
      # retuns the string needed to create this specific property of a defined type. This
      # method is **ONLY** called when the resource is created. It is not allowed to have
      # both an `on_apply` and a `on_create` definition on the type.
      #
      # @example
      #
      #  newproperty(:password) do
      #    on_create do
      #      "identified by #{resource[:password]}"
      #    end
      #  end
      #
      # @param [Method] block The code to be run on creating a resource. Although the code
      #                 customary returns just a string that is appended to the command, it can do
      #                 anything that is deemed nesceccary.
      #
      # @see on_create on the type for information on creating a resource
      #
      def on_create(&block)
        define_method(:on_create, &block) if block
      end

      #
      # retuns the string needed to modify this specific property of a defined type. This
      # method is **ONLY** called when the resource is modified. It is not allowed to have
      # both an `on_apply` and a `on_destroy` definition on the type.
      #
      # @example
      #
      #  newproperty(:password) do
      #    on_modify do
      #      "identified by #{resource[:password]}"
      #    end
      #  end
      #
      # @param [Method] block The code to be run modifying a resource. Although the code
      #                 customary returns just a string that is appended to the command, it can do
      #                 anything that is deemed nesceccary.
      #
      # @see on_modify on the type for information on modifying an existing resource
      #
      def on_modify(&block)
        define_method(:on_modify, &block) if block
      end

      #
      # maps a raw resource to retuns the string needed to modify this specific property of a type
      #
      # @example
      #
      #  newproperty(:password) do
      #    map do
      #     "identified by #{resource[:password]}"
      #    end
      #  end
      #
      # @param [Method] block The code to be run to pick a part of the raw_hash and use it as the value of this parameter
      #                 or property.
      #
      def to_translate_to_resource(&block)
        eigenclass = class << self; self; end
        eigenclass.send(:define_method, :translate_to_resource, &block)
      end
    end
  end
end
