require 'bundler'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

task :features do
  puts
  system("cucumber features --format progress") || exit(1)
end

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
end

task :default => [ :spec, :features ]
