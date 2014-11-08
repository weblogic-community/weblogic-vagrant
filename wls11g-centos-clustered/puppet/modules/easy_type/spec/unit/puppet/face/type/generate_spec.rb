# encoding: UTF-8
require 'spec_helper'
require 'puppet/face'

describe "puppet attribute generator" do

  let(:options) do
    {}
  end

  def remove_file(path)
    FileUtils.rm_r path if File.exists?(path)
  end

  before do
    FileUtils.cp('./templates/easy_type.rb.erb','./lib/puppet/type/my_type.rb')
    remove_file('./lib/puppet/type/my_type/my_attribute.rb')
    remove_file('./lib/puppet/type/shared/my_attribute.rb')
  end

  subject { Puppet::Face[:type, :current] }

  describe "option validation" do

    context "without any options" do

      it "should require a attribute type, a attribute name and a type name" do
        pattern = /wrong number of arguments/
        expect { subject.generate }.to raise_error ArgumentError, pattern
      end

      it "should require  a name" do
        pattern = /wrong number of arguments/
        expect { subject.generate('property')}.to raise_error ArgumentError, pattern
      end
    end

    it "should accept the --force option" do
      options[:force] = true
      expect { subject.generate('property', "my_attribute" , "my_type", options)}.to_not raise_error
    end

    it "should accept the --shared option" do
      options[:shared] = true
      expect { subject.generate('property', "my_attribute" , "my_type", options)}.to_not raise_error
    end

    it "should accept the --description option" do
      options[:description] = 'Just some description'
      expect { subject.generate('property', "my_attribute" , "my_type", options)}.to_not raise_error
    end

    it "should accept the --key option" do
      options[:key] = 'my_key'
      expect { subject.generate('property', "my_attribute" , "my_type", options)}.to_not raise_error
    end

  end

  describe "inline documentation" do
    subject { Puppet::Face[:type, :current].get_action :generate }
    its(:summary)     { should =~ /Create a parameter or property/im }
    its(:description) { should =~ /Create a parameter or a property/im }
    its(:examples)    { should =~ /To create a parameter for a custom easy type/}
  end

end
