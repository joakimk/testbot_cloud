require 'rubygems'
require 'thor'

module TestbotCloud
  class Cli < Thor
    include Thor::Actions
   
    def initialize(custom_opts = {})
      super
      @custom_opts = custom_opts
    end

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "new PROJECT_NAME", "Generate a testbot cloud project"
    def new(name)
      puts "Creating project: #{name}"
      template('templates/ec2/config.yml.erb', "#{name}/config.yml", @custom_opts)
      copy_file('templates/ec2/ec2_key.pem', "#{name}/ec2_key.pem", @custom_opts)
    end
  end
end

