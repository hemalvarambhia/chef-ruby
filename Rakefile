require 'bundler/setup'

# Rspec and ChefSpec
require 'rspec/core/rake_task'
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

# Integration tests. Kitchen.ci
require 'kitchen'
namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

# The default rake task should just run it all
desc 'Run all tests on Travis'
task travis: 'integration:vagrant'
