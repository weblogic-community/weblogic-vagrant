# encoding: UTF-8

require 'spec_helper'
require 'puppet/face'

describe "puppet type scaffold" do

  let(:options) do
    {}
  end

  def remove_file(path)
    FileUtils.rm_r path if File.exists?(path)
  end


  before do
    remove_file('./lib/puppet/provider')
    remove_file('./lib/puppet/type/my_type')
    remove_file('./lib/puppet/type/my_type.rb')
  end

  subject { Puppet::Face[:type, :current] }

  describe "option validation" do

    context "without any options" do

      it "should require a generator name and a name" do
        pattern = /wrong number of arguments/
        expect { subject.scaffold }.to raise_error ArgumentError, pattern
      end

      it "should require  a name" do
        pattern = /wrong number of arguments/
        expect { subject.scaffold(:easy_type)}.to raise_error ArgumentError, pattern
      end
    end


    it "should accept the --force option" do
      options[:force] = true
      expect { subject.scaffold(:easy_type, "my_type", options)}.to_not raise_error
    end

    it "should accept the --provider option" do
      options[:provider] = 'test'
      expect { subject.scaffold(:easy_type, "my_type", options)}.to_not raise_error
    end

    it "should accept the --description option" do
      options[:description] = 'Just some description'
      expect { subject.scaffold(:easy_type, "my_type", options)}.to_not raise_error
    end

    it "should accept the --namevar option" do
      options[:namevar] = 'a_name_var'
      expect { subject.scaffold(:easy_type, "my_type", options)}.to_not raise_error
    end

  end

  describe "inline documentation" do
    subject { Puppet::Face[:type, :current].get_action :scaffold }

    its(:summary)     { should =~ /Create a scaffold/im }
    its(:description) { should =~ /Create the correct directories/im }
    its(:examples)    { should =~ /To create a scaffold for a new custom/}
  end

end
