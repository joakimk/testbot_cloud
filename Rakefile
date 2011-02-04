require 'bundler'
require 'cucumber'
require 'cucumber/rake/task'

Bundler::GemHelper.install_tasks

desc "Run specs"
task :spec do
  require 'minitest/autorun'
  Dir["spec/**/*_spec.rb"].each { |test| require(File.expand_path(test)) }
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format progress"
end

desc "Run tests"
task :default => [ :spec, :features ] do
end

