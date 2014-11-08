require 'spec_helper'
require 'easy_type/mungers'

describe EasyType::Mungers::Integer do
	include EasyType::Mungers::Integer

	it "returns an integer when given an integer like string" do
		expect(unsafe_munge('1')).to eql 1
	end

	it "raises ArgumentError on floating number string" do
		expect{unsafe_munge('1.3')}.to raise_error(ArgumentError)
	end

	it "raises ArgumentError on a character string" do
		expect{unsafe_munge('bert')}.to raise_error(ArgumentError)
	end

end

describe EasyType::Mungers::Size do
	include EasyType::Mungers::Size

	it "returns an integer when given an integer" do
		expect(unsafe_munge(100)).to eql 100
	end

	it "returns an float when given a float" do
		expect(unsafe_munge(100.5)).to eql 100.5
	end

	it "returns an integer when given an integer like string" do
		expect(unsafe_munge('100')).to eql 100
	end

	it "returns an integer * 1024 when it an 'K' is appended" do
		expect(unsafe_munge('100K')).to eql 102400
	end

	it "returns an integer * 1024 * 1024 when it an 'M' is appended" do
		expect(unsafe_munge('100M')).to eql 104857600
	end

	it "raises RuntimeError on floating number string" do
		expect{unsafe_munge('1.3')}.to raise_error(RuntimeError)
	end

end

describe EasyType::Mungers::Upcase do
	include EasyType::Mungers::Upcase

	it "returns an lowercase version of the input when it contains non-capitals" do
		expect(unsafe_munge('Hallo')).to eql 'HALLO'
	end
	it "returns an the same value if string contains only capitals" do
		expect(unsafe_munge('HALLO')).to eql 'HALLO'
	end

end

describe EasyType::Mungers::Downcase do
	include EasyType::Mungers::Downcase

	it "returns an lowercase version of the input when it contains capitals" do
		expect(unsafe_munge('Hallo')).to eql 'hallo'
	end
	it "returns an the same value if string contains no capitals" do
		expect(unsafe_munge('hallo')).to eql 'hallo'
	end


end
