require 'spec_helper'
require 'easy_type/file_includer'

describe EasyType::FileIncluder do
	include EasyType::FileIncluder

	context "a file does exist" do

		before do
			include_file "easy_type/include_check.rb"
		end

		it "evaluates the ruby code in the file" do
			expect(file_is_included).to be true
		end
	end


	context "a file does not exist" do

		it "raises an ArgumentError" do
			expect{ include_file "easy_type/nonexisting_file.rb"}.to raise_error(ArgumentError)
		end
	end

end

