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
      Fog.mock! if ENV['INTEGRATION_TEST']
      load_config

      compute = Fog::Compute.new(@provider_config)
      threads = []
      puts "Starting #{@runner_count} runners..."
      @runner_count.times do
        threads << Thread.new do
          server = compute.servers.create(@runner_config) 
          server.wait_for { ready? }
          puts "#{server.id} up, installing testbot..."
          puts "#{server.id} ready."
          Network::Factory.create(server).bootstrap!
        end
      end
      threads.each { |thread| thread.join }
    end

    desc "stop", "Destroy all servers created with the testbot key"
    def stop
      config = YAML.load_file("config.yml")
      provider = config["provider"].symbolize_keys
      
      compute = Fog::Compute.new(provider)
      compute.servers.each do |server|
        p server
        #if server.state == "running" #&& server.key_name == runner[:key_name]
          puts "Shutting down #{server.id}..."
          server.destroy
        #end
      end
    end

    private

    def load_config
      config = YAML.load_file("config.yml")
      @provider_config = config["provider"].symbolize_keys
      @runner_config = config["runner"].symbolize_keys
      @runner_count = config["runners"]
    end
  end
end

