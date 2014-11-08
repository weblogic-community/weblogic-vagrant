require 'spec_helper'
require 'easy_type'

describe EasyType::Type do

  before do
    module Puppet
      newtype(:test) do
        include EasyType
        newparam(:name) do
          isnamevar
        end
      end
    end

  end

  after do
    Puppet::Type.rmtype(:test)
  end

  subject { Puppet::Type::Test.new(:name => 'test/name') }


  describe ".on_create" do

    before do

      module Puppet
        class Type
          class Test
            on_create do
              "done"
            end
          end
        end
      end
    end

    it "adds a instance method on_create" do
      expect( subject.on_create).to eql('done')
    end
  end

  describe ".on_destroy" do

    before do
      module Puppet
        class Type
          class Test

            on_destroy do
              "done"
            end
          end
        end
      end
    end

    it "adds a instance method on_destroy" do
      expect( subject.on_destroy).to eql('done')
    end

  end


  describe ".map_title_to_attribues" do

    before do
      module Puppet
        class Type
          class Test
            newparam(:second_name) do
              isnamevar
            end
          end
        end
      end
    end

    context 'passing symbols' do

      before do
        module Puppet
          class Type
            class Test
              map_title_to_attributes(:name, :second_name) do
                /^(.*)\/(.*)$/
              end
            end
          end
        end
      end

      it "adds a class method title_patterns" do
        expect( subject.class.title_patterns).to eql([[/^(.*)\/(.*)$/, [[:name, nil], [:second_name, nil]]]])
      end
    end

    context 'passing strings' do

      before do
        module Puppet
          class Type
            class Test
              map_title_to_attributes('name', 'second_name') do
                /^(.*)\/(.*)$/
              end
            end
          end
        end
      end

      it "adds a class method title_patterns" do
        expect( subject.class.title_patterns).to eql([[/^(.*)\/(.*)$/, [[:name, nil], [:second_name, nil]]]])
      end
    end


    context 'passing a Array with an Array' do


      before do

        module Kernel

          def a_proc
            @@a_prox ||= lambda {|x| x}
          end
        end

        module Puppet
          class Type
            class Test
              map_title_to_attributes('name', [:second_name, a_proc] ) do
                /^(.*)\/(.*)$/
              end
            end
          end
        end
      end

      it "adds a class method title_patterns containing the proc" do
        expect( subject.class.title_patterns).to eql([[/^(.*)\/(.*)$/, [[:name, nil], [:second_name, a_proc]]]])
      end
    end


    context 'passing a Array with an Hash' do


      before do

        module Kernel

          def a_proc
            @@a_prox ||= lambda {|x| x}
          end
        end

        module Puppet
          class Type
            class Test
              map_title_to_attributes('name', :second_name => a_proc ) do
                /^(.*)\/(.*)$/
              end
            end
          end
        end
      end

      it "adds a class method title_patterns containing the proc" do
        expect( subject.class.title_patterns).to eql([[/^(.*)\/(.*)$/, [[:name, nil], [:second_name, a_proc]]]])
      end
    end
  end

  describe ".on_modify" do

    before do
      module Puppet
        class Type
          class Test
            on_modify do
              "done"
            end
          end
        end
      end
    end

    it "adds a instance method on_modify" do
      expect( subject.on_modify).to eql('done')
    end

  end

  describe ".to_get_raw_resources" do

    before do
      module Puppet
        class Type
          class Test
            to_get_raw_resources do
              "done"
            end
          end
        end
      end
    end


    it "adds a class method get_raw_resources" do
      expect( Puppet::Type::Test.get_raw_resources).to eql('done')
    end

  end

  describe ".property & .parameter" do

    before do
      module Puppet
        class Type
          class Test

            property  :a_test
            parameter :b_test
            parameter :shared_one
          end
        end
      end
    end

    it "defines a property" do
      expect( defined?(Puppet::Type::Test::A_test)).to be_truthy
    end

    it "defines a parameter" do
      expect( defined?(Puppet::Type::Test::ParameterB_test)).to be_truthy
    end

    it "defines a property in the shared directory" do
      expect( defined?(Puppet::Type::Test::Shared_one)).to be_truthy
    end

    it "adds a conveniance access method" do
      skip
    end

  end


  describe ".group" do

    context "a group with invalid content" do
      subject do
        class Puppet::Type::Test
          group do
            erronous_command
          end
        end
      end

      it "raises an error" do
        expect{subject}.to raise_error(NameError)
      end
    end


    context "a group with valid content" do
      before do
        module Puppet
          class Type
            class Test
              group(:test) do
                parameter :a_test
                property  :b_test
              end
            end
          end
        end
      end

      it "defines a parameter" do
        expect( defined?(Puppet::Type::Test::ParameterB_test)).to be_truthy
      end

      it "defines a property" do
        expect( defined?(Puppet::Type::Test::A_test)).to be_truthy
      end

      it "defines a type" do
        expect( Puppet::Type::Test.groups).to include(:test)
      end

      it "the group to include the parameter" do
        expect( Puppet::Type::Test.groups.include_property?(Puppet::Type::Test::ParameterB_test)).to be_truthy
      end

      it "the group to include the property" do
        expect( Puppet::Type::Test.groups.include_property?(Puppet::Type::Test::A_test)).to be_truthy
      end


    end
  end

  describe ".set_command" do


    context "is called with a valid method" do
      before do
        module Puppet
          class Type
            class Test
              def self.an_existing_method
                "called a test method"
              end

              set_command :an_existing_method
            end
          end
        end
      end

    end

    context "is called with just a symbol, representing no method" do

      before do
        module Puppet
          class Type
            class Test

              set_command :echo
            end
          end
        end
      end


      it "defines a method named after the command" do
        # Using the .map {|m| m.to_sym} because Ruby 1.8.7 returns strings instead of symbols
        expect(subject.class.methods.map {|m| m.to_sym}).to include(:echo)
      end


    end

  end

end

