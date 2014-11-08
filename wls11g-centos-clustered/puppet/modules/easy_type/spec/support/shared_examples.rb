shared_examples "executes the command with the line" do

	it "executes the command with the line" do
		expect(subject).to eql("main\n")
	end
end


shared_examples "no before results set" do

	it "no before results set" do
		subject
		expect(object.results(:before)).to be_empty
	end
end

shared_examples "no after results set" do

	it "no after results set" do
		subject
		expect(object.results(:after)).to be_empty
	end
end

shared_examples "before results set" do

	it "before results set" do
		subject
		expect(object.results(:before)).to eql("before\n")
	end
end

shared_examples "after results set" do
	it "after results set" do
		subject
		expect(object.results(:after)).to eql("after\n")
	end
end


shared_examples "has no entries" do
	it "has no entries" do
		expect(subject.entries).to be_empty
	end
end


shared_examples "a block with acceptable commands passed" do
	it "has at least 1 entry" do
		expect(subject.entries.size).to be >= 1
	end
end


shared_examples "an event method" do | method_name|

	describe ".#{method_name}" do

		before do
			Test.class_eval("#{method_name} {'done'}")
		end

		subject { Test.new}

		it "adds a instance method #{method_name} on the property" do
			expect( subject.send("#{method_name}")).to eql('done')
		end
	end
end
