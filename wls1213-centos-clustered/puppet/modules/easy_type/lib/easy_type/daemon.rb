# encoding: UTF-8
require 'open3'
require 'timeout'

module EasyType
  #
  # The EasyType:Daemon class, allows you to easy write a daemon for your application utility.
  # To get it working, subclass from
  #
  # rubocop:disable ClassVars
  class Daemon
    SUCCESS_SYNC_STRING = /~~~~COMMAND SUCCESFULL~~~~/
    FAILED_SYNC_STRING = /~~~~COMMAND FAILED~~~~/
    TIMEOUT = 60 # wait 60 seconds as default

    @@daemons = {}
    #
    # Check if a daemon for this identity is running. Use this to determin if you need to start the daemon
    #
    def self.run(identity)
      daemon_for(identity) if daemonized?(identity)
    end

    ##
    # Initialize a command daemon. In the command daemon, the specified command is run in a daemon process.
    # The specified command must readiths commands from stdi and output any results from stdout.
    # A daemon proces must be identified by an identifier string. If you want to run multiple daemon processes,
    # say for connecting to an other, you can use a different name. 
    #
    # If you want to run the daemon as an other user, you can specify a user name, the process will run under.
    # This must be an existing user.
    # 
    # Checkout sync on how to sync the output. You can specify a timeout value to have the daemon read's
    # timed out if it dosen't get an expected answer within that time.
    #
    #
    #
    def initialize(identifier, command, user)
      if @@daemons[identifier]
        return @@daemons[identifier]
      else
        initialize_daemon(user, command)
        @identifier = identifier
        @@daemons[identifier] = self
      end
    end

    #
    # Pass a command to the daemon to execute
    #
    def execute_command(command)
      @stdin.puts command
    end

    #
    # Wait for the daemon process to return a valid sync string. YIf your command passed
    # ,return the string '~~~~COMMAND SUCCESFULL~~~~'. If it failed, return the string '~~~~COMMAND FAILED~~~~'
    #
    #
    def sync( timeout = TIMEOUT, &proc)
      while true do
        line = timed_readline(timeout)
        Puppet.debug "#{line}"
        break if line =~ SUCCESS_SYNC_STRING
        fail 'command in deamon failed.' if line =~ FAILED_SYNC_STRING
        proc.call(line) if proc
      end
    end

    private

    def timed_readline(timeout)
      Timeout.timeout(timeout) do
        @stdout.readline
      end
      rescue Timeout::Error
        fail "timeout on reading expected output from daemon process."
    end

    # @nodoc
    def self.daemonized?(identity)
      !daemon_for(identity).nil?
    end

    # @nodoc
    def self.daemon_for(identity)
      @@daemons[identity]
    end

    # @nodoc
    def initialize_daemon(user, command)
      if user
        @stdin, @stdout, @stderr = Open3.popen3("su - #{user}")
        execute_command(command)
      else
        @stdin, @stdout, @stderr = Open3.popen3(command)
      end
      at_exit do
        Puppet.debug "Quiting daemon #{@identifier}..."
        @stdin.close
        @stdout.close
        @stderr.close
      end
    end
  end
  # rubocop:enable ClassVars
end
