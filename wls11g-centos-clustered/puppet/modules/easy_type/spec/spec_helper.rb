begin
	require 'coveralls'
	Coveralls.wear! do
		add_filter 'test_type.rb'
	end
rescue LoadError
	puts "No Coveralls support"
end

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../lib'))
require 'rubygems'
require 'rspec/mocks'
require 'rspec/its'
require 'puppet'
require 'puppetlabs_spec_helper/puppetlabs_spec_helper'
require 'support/shared_examples'


RSpec.configure do |configuration|
  configuration.mock_with :rspec do |configuration|
    configuration.syntax = [:expect, :should]
    #configuration.syntax = :should
    #configuration.syntax = :expect
  end
end