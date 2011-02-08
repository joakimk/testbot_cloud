require 'rubygems'
require 'thor'
require 'fog'
require 'yaml'
require 'active_support/core_ext/hash/keys'

module TestbotCloud
  class Cli < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__) + "/templates"
    end

    desc "new PROJECT_NAME", "Generate a testbot cloud project"
    def new(name)
      copy_file "config.yml", "#{name}/config.yml"
      copy_file "runner.sh", "#{name}/bootstrap/runner.sh"
    end

    desc "start", "Start a testbot cluster as configured in config.yml"
    def start
      config = YAML.load_file("config.yml")
      provider = config["provider"].symbolize_keys
      runner = config["runner"].symbolize_keys
      runner_count = config["runners"]
     
      puts "NOTE: Dry run, fake servers:" 
      Fog.mock!

      compute = Fog::Compute.new(provider)
      threads = []
      puts "Staring #{runner_count} runners..."
      runner_count.times do
        threads << Thread.new do
          server = compute.servers.create(runner) 
          server.wait_for { ready? }
          puts "#{server.id} up, installing testbot..."
          sleep 1
          puts "#{server.id} ready."
        end
      end
      threads.each { |thread| thread.join }
    end

    desc "stop", "Destroy all servers created with the testbot key"
    def stop
      Fog.mock!

      config = YAML.load_file("config.yml")
      provider = config["provider"].symbolize_keys
      
      compute = Fog::Compute.new(provider)
      compute.servers.each do |server|
        #if server.state == "running" #&& server.key_name == runner[:key_name]
          puts "Shutting down #{server.id}..."
          server.destroy
        #end
      end
    end
  end
end

