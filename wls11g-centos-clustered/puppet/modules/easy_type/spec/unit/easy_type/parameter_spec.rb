require 'spec_helper'
require 'easy_type/parameter'

describe EasyType::Parameter do

	before do
		class Test
			include EasyType::Parameter
		end
	end

	after do
		Object.send(:remove_const, :Test)
	end

	test_methods = ['on_create', 'on_modify']

	test_methods.each do | method_name|
		it_behaves_like "an event method", method_name
	end

	describe ".on_apply" do

		it_behaves_like "an event method", 'on_apply'

		test_methods.each do | method_name|

			context "when method #{method_name} defined" do
				before do
					Test.class_eval("#{method_name} { 'done'} ")
				end

				it "fails if we run on_apply" do
					expect{ Test.class_eval("on_apply { 'done'}")}.to raise_error
				end
			end
		end
	end


	describe ".to_translate_to_resource" do

		before do
			class Test
				to_translate_to_resource do
					"done"
				end
			end
		end


		it "adds a class method translate_to_resource" do
			expect( Test.translate_to_resource).to eql('done')
		end

	end


end

