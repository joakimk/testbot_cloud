require 'bundler'
Bundler::GemHelper.install_tasks

task :spec do
  require 'minitest/autorun'
  Dir["spec/**/*_spec.rb"].each { |test| require(File.expand_path(test)) }
end

task :default => :spec do
end
