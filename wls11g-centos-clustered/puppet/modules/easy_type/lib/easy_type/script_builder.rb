# encoding: UTF-8
require 'easy_type/command_entry'
require 'easy_type/blank_slate'

module EasyType
  #
  # The command builder is a class that helps building an OS command sequence. You can specify
  # a base command on creation. With the << you can add parameters and options in the order you would
  # like. Sometimes you need to execute commands before and/or after the base command. The ScriptBuilder
  # supports this by using the `before` and `after` methods
  #
  # rubocop:disable ClassLength
  class ScriptBuilder
    attr_reader :acceptable_commands, :binding

    def initialize(options = {}, &block)
      @entries ||= []
      @acceptable_commands = Array(options.fetch(:acceptable_commands) { [] })
      @binding = options[:binding]
      @context = BlankSlate.new
      if @binding
        CommandEntry.set_binding(@binding)
        copy_resource_info
      end
      @acceptable_commands.each do | command|
        @context.eigenclass.send(:define_method, command) do |*args|
          @entries[type] << CommandEntry.new(command, args)
        end
      end
      @context.type = :main
      @context.instance_eval(&block) if block
    end

    def entries(type = :main)
      @context.entries[type]
    end

    def default_command
      @acceptable_commands.first || ''
    end

    def last_command(type = :main)
      entries(type).last
    end

    def add(line, options = {}, &block)
      if block
        add_to_queue(:main, line, options, &block)
      else
        entries(:main) << CommandEntry.new(default_command, line, options) unless line.nil? # special case
      end
      nil
    end

    def <<(line)
      catch(:no_last_commands) do
        check_last_command
        last_command.arguments << line if line
      end
      nil
    end

    #
    # For backward compatibility
    #
    def line
      catch(:no_last_commands) do
        check_last_command
        last_command.arguments.join(' ')
      end
    end
    #
    # For backward compatibility
    #
    def line=(line)
      catch(:no_last_commands) do
        check_last_command
        last_command.arguments.clear
        last_command.arguments << line.split(' ')
      end
    end

    def append(line = nil, &block)
      last_argument = last_command.arguments.pop
      if block
        new_argument = last_argument + @context.instance_eval(&block)
      else
        new_argument = last_argument + line
      end
      last_command.arguments << new_argument
      nil
    end

    def before(line = nil, options = {}, &block)
      add_to_queue(:before, line, options, &block)
      nil
    end

    def after(line = nil, options = {}, &block)
      add_to_queue(:after, line, options, &block)
      nil
    end

    def execute
      @context.execute
      results
    end

    def results(type = :main)
      @context.results[type].join("\n")
    end

    private

    def check_last_command
      unless last_command
        Puppet.debug 'no command specified'
        throw(:no_last_commands)
      end
    end

    def add_to_queue(queue, line, options, &block)
      fail ArgumentError, 'block or line must be present' unless block || line
      if line
        entries(queue) << CommandEntry.new(default_command, line, options)
      else
        @context.type = queue
        @context.instance_eval(&block)
      end
    end

    def copy_resource_info
      return unless @binding.respond_to?(:to_hash)
      @binding.to_hash.each_pair do | key, value|
        @context.eigenclass.send(:define_method, key) do
          value
        end
      end
    end
  end
end
# rubocop:enable ClassLength
