require 'easy_type/group'

describe EasyType::Group do

	let(:object) { described_class.new}

	describe ".include?" do 

		subject { object.include?(group) }

		context "group exists" do

			let(:group) {:existing_group}
			before do 
				object.add(:existing_group, Object)
			end

			it "returns true" do
				expect( subject ).to be_truthy
			end
		end

		context "group doesn't exist" do

			let(:group) {:fake_group}

			it "returns false" do
				expect( subject).to be_falsey
			end
		end
	end

	describe ".include_property?" do

		subject { object.include_property?(property)}

		before do 
			object.add(:existing_group, Object)
		end

		context "property exists in groups" do

			let(:property) {Object}

			it "returns true" do
				expect(subject).to be_truthy
			end

		end

		context "property doesn't exist in groups" do
			let(:property) { String}

			it "returns false" do
				expect(subject).to be_falsey
			end

		end
	end

	describe ".add" do

		before do
			object.add(:my_group, Float)
		end

		it "add's the group" do
			expect(object.include?(:my_group)).to be_truthy 
		end

		it "add's the class" do
			expect(object.include_property?(Float)).to be_truthy 
		end

	end	

	describe ".contents_for" do

		subject { object.contents_for(:group)}

		context "unkown group" do
			it "raises an error" do
				expect{subject}.to raise_error
			end
		end

		context "has contents" do

			before do
				object.add(:group, Integer)
			end

			it "returns an array with the contents" do
				expect(subject).to eq [Integer]
			end
		end
	end
end