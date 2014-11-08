require 'spec_helper'
require 'easy_type/validators'

describe EasyType::Validators::Name do
	include EasyType::Validators::Name

	it "does nothing on a valid name string" do
		expect(unsafe_validate('bert')).to eql nil
	end

	it "raises ArgumentError on empty string" do
		expect{unsafe_validate('')}.to raise_error(Puppet::Error)
	end

	it "raises ArgumentError on string with whitespace" do
		expect{unsafe_validate('bert hajee')}.to raise_error(Puppet::Error)
	end

end


describe EasyType::Validators::Integer do
	include EasyType::Validators::Integer

	it "does nothing on a valid integer string" do
		expect(unsafe_validate('123')).to eql nil
	end

	it "does nothing on a valid integer" do
		expect(unsafe_validate(123)).to eql nil
	end

	it "raises ArgumentError on a real " do
		expect{unsafe_validate(3.5)}.to raise_error(Puppet::Error)
	end


	it "raises ArgumentError on empty string" do
		expect{unsafe_validate('')}.to raise_error(Puppet::Error)
	end

	it "raises ArgumentError on string with characters" do
		expect{unsafe_validate('xxx')}.to raise_error(Puppet::Error)
	end

	it "raises ArgumentError on string with flating number" do
		expect{unsafe_validate('1.1')}.to raise_error(Puppet::Error)
	end



end
