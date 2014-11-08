source :rubygems

gem 'puppet', '>= 2.7.0'
gem 'facter', '>= 1.6.2'

group :test, :development do
  gem 'yard',  '~> 0.8.3'
  gem 'redcarpet'
  gem 'rspec', '~> 2.10.0'
  gem 'mocha', '~> 0.10.5'
end

if File.exists? "#{__FILE__}.local"
  eval(File.read("#{__FILE__}.local"), binding)
end
