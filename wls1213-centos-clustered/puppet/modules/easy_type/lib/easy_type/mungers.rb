# encoding: UTF-8
#
#
# Define all common mungers available for all types
#
module EasyType
  #
  # The Integer munger, munges a specified value to an Integer.
  #
  module Mungers

    [Integer, String, Array, Float].each do| klass|
      module_eval(<<-END_RUBY, __FILE__, __LINE__)
        # @nodoc
        # @private
        module #{klass}
          def unsafe_munge(value)
            #{klass}(value)
          end
        end
      END_RUBY
    end
    #
    # The Size munger, munges a specified value to an Integer.
    #
    module Size
      # @private
      def unsafe_munge(size)
        return size if size.is_a?(Numeric)
        case size
        when /^\d+(K|k)$/ then size.chop.to_i * 1024
        when /^\d+(M|m)$/ then size.chop.to_i * 1024 * 1024
        when /^\d+(G|g)$/ then size.chop.to_i * 1024 * 1024 * 1024
        when /^\d+$/ then size.to_i
        else
          fail('invalid size')
        end
      end
    end

    #
    # The Upcase munger, munges a specified value to an uppercase String
    #
    module Upcase
      # @private
      def unsafe_munge(string)
        string.upcase
      end
    end

    #
    # The Downcase munger, munges a specified value to an lowercase String
    #
    module Downcase
      def unsafe_munge(string)
        string.downcase
      end
    end
  end
end
