#!/usr/bin/env ruby

require 'spec_helper'
require 'easy_type/script_builder'


describe EasyType::ScriptBuilder do

	let(:options) { {:acceptable_commands => [:my]} }

	describe "#new" do

		let(:options) { {} }
		subject { described_class.new(options) }

		context "no options passed" do
			let(:options) {{}}

			it "has no default command" do
				expect(subject.default_command).to be_empty
			end

			it "has no acceptable commands" do
				expect(subject.acceptable_commands).to be_empty
			end

			it "has no binding" do
				expect(subject.binding).to be_nil
			end

			it_behaves_like "has no entries"

		end

		context "binding passed as options" do

			let(:my_binding) { binding}
			let(:options) { {:binding => my_binding} }

			it "binding is set" do
				expect(subject.binding).to eq my_binding
			end
		end


		context "acceptable commands passed as options" do

			let(:options) { {:acceptable_commands => [:first, :second]} }

			it "acceptable_commands is set" do
				expect(subject.acceptable_commands).to eq([:first, :second])
			end


			it "has a default command" do
				expect(subject.default_command).to eq(:first)
			end

			it_behaves_like "has no entries"

		end

		context "a block with acceptable commands passed" do

			subject do 
				described_class.new(options) do 
					first 'something'
				end
			end

			let(:options) { {:acceptable_commands => [:first]} }

			it_behaves_like "a block with acceptable commands passed"

		end
	end

	describe '#last_command' do

		subject { object.last_command}

		context "no commands entered yet" do

			let(:object) {described_class.new(options)}

			it "returns nil" do
				expect(subject).to be_nil
			end
		end

		context "some commands entered" do

			let(:object) do
				described_class.new(options) do 
					my 'first'
					my 'second'
					my 'third'
				end
			end

			it "returns the last command" do
				expect(subject.arguments).to eq ['third']
			end
		end
	end

	describe "<<" do

		subject { object << 'some text'}

		context "no command given yet" do

			let(:object) {described_class.new(options)}

			it "Show's a debug message for this situation" do
				expect(Puppet).to receive(:debug)
				subject
			end
		end

		context "at least one command given" do

			let(:object) do
				described_class.new(options) do 
					my 'first'
				end
			end

			it "add's the line to the last command" do
				subject
				expect(object.last_command.arguments.last).to eq 'some text'
			end
		end
	end

	describe "#before" do

		let(:object) do
			described_class.new(options)
		end

		context "a block passed" do
			subject do
				object.before do
					my 'before'
				end
			end


			it "add's a before command" do
				subject
				expect(object.last_command(:before).arguments.first).to eq 'before'
			end
		end

		context "a line given" do
			subject {object.before('before')}


			it "add's an before command" do
				subject
				expect(object.last_command(:before).arguments.first).to eq 'before'
			end
		end


		context "no block and no line given" do

			subject do
				object.before
			end

			it "raises an error" do
				expect{ subject}.to raise_error
			end

		end

	end

	describe "#after" do

		let(:object) do
			described_class.new(options)
		end

		context "a block given" do
			subject do
				object.after do
					my 'after'
				end
			end


			it "add's an after command" do
				subject
				expect(object.last_command(:after).arguments.first).to eq 'after'
			end
		end

		context "a line given" do
			subject {object.after('after')}


			it "add's an after command" do
				subject
				expect(object.last_command(:after).arguments.first).to eq 'after'
			end
		end


		context "no block and no line given" do

			subject do
				object.after
			end

			it "raises an error" do
				expect{ subject}.to raise_error
			end

		end

	end


	describe "#execute" do


		let(:object) do
			described_class.new(:acceptable_commands => :echo) do
				echo 'main'
			end
		end

		subject {object.execute}

		context "no before & no after set" do
			it_behaves_like "executes the command with the line" 
			it_behaves_like "no before results set"
			it_behaves_like "no after results set"
		end

		context "with before & with after set" do

			before do
				object.before do
					echo 'before'
				end
				object.after do
					echo 'after'
				end
			end

			it_behaves_like "executes the command with the line" 
			it_behaves_like "before results set"
			it_behaves_like "after results set"
		end


		context "with an existing method in the binding" do


			def hallo(line, options)
				"#{line}\n"
			end

			let(:object) do
				described_class.new(:binding => self , :acceptable_commands => :hallo) do
					hallo 'main'
				end
			end

			it_behaves_like "executes the command with the line" 
			it_behaves_like "no before results set"
			it_behaves_like "no after results set"
		end

	end

	describe "#line" do

		subject {object.line}


		context "no command given yet" do

			let(:object) {described_class.new(options)}

			it "Show's a debug message for this situation" do
				expect(Puppet).to receive(:debug)
				subject
			end
		end


		context "a command already entered" do
			let(:object) do
				described_class.new(:acceptable_commands => :echo) do
					echo '1 2 3'
				end
			end

			it "returns the last line" do
				expect(subject).to eq '1 2 3'
			end

		end


	end


	describe "#line=" do

		subject {object.line = 'a b c'}


		context "no command given yet" do

			let(:object) {described_class.new(options)}

			it "Show's a debug message for this situation" do
				expect(Puppet).to receive(:debug)
				subject
			end
		end


		context "a command already entered" do

			let(:object) do
				described_class.new(:acceptable_commands => :echo) do
					echo '1 2 3'
				end
			end


			it "returns the last line" do
				subject
				expect(object.line).to eq 'a b c'
			end

		end


	end




end