require 'rubygems'
require 'thor'
require File.expand_path(File.join(File.dirname(__FILE__), 'providers/ec2.rb'))

module TestbotCloud
  class Cli < Thor
    include Thor::Actions
   
    DEFAULT_PROVIDER = :ec2

    def self.providers=(providers)
      @@providers = providers
    end

    def self.source_root
      File.dirname(__FILE__) + "/providers/templates"
    end

    desc "new PROJECT_NAME", "Generate a testbot cloud project"
    def new(name)
      @@providers[DEFAULT_PROVIDER].new(self).generate_project(name)
    end
  end
end

