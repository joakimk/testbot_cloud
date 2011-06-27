require 'bundler'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format progress"
end

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
end

task :default => [ :spec, :features ]

