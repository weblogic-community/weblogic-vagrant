# encoding: UTF-8
require 'version_differentiator'

# @nodoc
class CommandEntry
  attr_reader     :command, :arguments, :context

  # rubocop:disable ClassVars
  def self.set_binding(the_binding)
    @@binding = the_binding
  end
  # rubocop:enable ClassVars

  def initialize(command, arguments, options = {})
    @command    = command
    @arguments  = arguments.is_a?(Array) ? arguments : [arguments]
    @options    = options
  end

  def execute
    normalized_command = ''
    ruby_18 { normalized_command = command.to_s }
    ruby_19 { normalized_command = command.to_sym }
    if @@binding.methods.include?(normalized_command)
      @@binding.send(normalized_command, normalized_arguments, @options)
    else
      full_command = arguments.dup.unshift(command).join(' ')
      Puppet::Util::Execution.execute(full_command, :failonfail => true)
    end
  end

  private

  def normalized_arguments
    @arguments.is_a?(Array) ? @arguments.join(' ') : @arguments
  end
end
