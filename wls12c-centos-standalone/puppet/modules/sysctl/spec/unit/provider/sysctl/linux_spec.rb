require 'puppet'
require 'fileutils'
require 'mocha'

RSpec.configure do |config|
  config.mock_with :mocha
end

describe 'The sysctl provider for the sysctl type' do
  let(:test_dir) { File.join('/tmp', Time.now.to_i.to_s) }
  let(:test_file) { File.join('/tmp', Time.now.to_i.to_s,'sysctl.conf') }
  let(:resource) { Puppet::Type::Sysctl.new({:name => 'vm.swappiness', :path => test_file}) }
  subject { Puppet::Type.type(:sysctl).provider(:linux).new(resource) }

  before :each do
    FileUtils.mkdir_p(test_dir)
  end

  after :each do
    FileUtils.rm_rf(File.dirname(test_file)) if File.exists?(test_file)
    FileUtils.rm_rf(test_dir) if File.exists?(test_dir)
  end

  it 'should run sysctl to see if the key exists and return true if it does' do
    subject.expects(:sysctl).with('-n','vm.swappiness').returns(0)
    subject.exists?.should == true
  end

  it 'should run sysctl to see if the key exists' do
    resource[:name] = 'vm.swappines'
    subject.expects(:sysctl).with('-n','vm.swappines').returns('error: "vm.swappines" is an unknown key')
    subject.exists?.should == false
  end

  it 'should return permanent=no if the key doesn\'t exist in the target path' do
#   resource[:path] = test_file
    subject.permanent.should == 'no'
  end

  it 'should return permanent=yes if the key exists in the path' do
    File.open(test_file,'w') do |fh|
      fh.write("vm.swappiness = 0")
    end
    subject.permanent.should == 'yes'
  end

  it 'should get rid of an entry in the file if destroyed' do
    FileUtils.mkdir_p(test_dir)
    File.open(test_file,'w') do |fh|
      fh.write("vm.swappiness = 0")
    end
    subject.destroy
    subject.permanent.should == 'no'
  end

  it 'should create a non-existent path target if it does not exist when called to make something permanent' do
    resource[:value] = 0
    subject.permanent=('yes')
    subject.permanent.should == 'yes'
    subject.expects(:sysctl).with('-n','vm.swappiness').returns("0")
    subject.value.should == '0'
  end

  it 'should get update an entry in the file if it changes' do
    resource[:value] = 1
    FileUtils.mkdir_p(test_dir)
    File.open(test_file,'w') do |fh|
      fh.write("vm.swappiness = 0")
    end
  end








end
