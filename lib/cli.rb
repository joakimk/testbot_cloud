require 'rubygems'
require 'thor'

module TestbotCloud
  class Cli < Thor
    include Thor::Actions

    def self.providers=(providers)
      @@providers = providers
    end

    def self.source_root
      File.dirname(__FILE__) + "/providers/templates"
    end

    desc "new PROJECT_NAME", "Generate a testbot cloud project"
    def new(name)
      @@providers[TestbotCloud::DEFAULT_PROVIDER].new(self).generate_project(name)
    end
  end
end

