require 'fog'
require 'yaml'
require 'active_support/core_ext/hash/keys'
require File.expand_path(File.join(File.dirname(__FILE__), 'server/factory.rb'))

module TestbotCloud
  class Cluster

    def initialize
      Fog.mock! if ENV['INTEGRATION_TEST']
      load_config

      @compute = Fog::Compute.new(@provider_config)
    end

    def start
      puts "Starting #{@runner_count} runners..."
      for_each_runner_in_a_thread do |mutex|
        server = @compute.servers.create(@runner_config) 
        
        puts "#{server.id} is being created..."
        wait_for_server_to_be_ready(server)

        puts "#{server.id} is up, installing testbot..."
        if Server::Factory.create(@compute, server).bootstrap!(mutex)
          puts "#{server.id} ready."
        else
          puts "#{server.id} failed, shutting down."
          server.destroy
        end
      end
    end

    def stop
      @compute.servers.each do |server|
        if server.ready?
          puts "Shutting down #{server.id}..."
          server.destroy 
        end
        #if server.state == "running" #&& server.key_name == runner[:key_name]
        #end
      end
    end

    private

    def for_each_runner_in_a_thread
      threads = []
      mutex = Mutex.new
      @runner_count.times do
        threads << Thread.new do
          yield mutex
        end
      end
      threads.each { |thread| thread.join }
    end

    def load_config
      config = YAML.load_file("config.yml")
      @provider_config = config["provider"].symbolize_keys
      @runner_config = config["runner"].symbolize_keys
      @runner_count = config["runners"]
    end

    def wait_for_server_to_be_ready(server)
      5.times do
        begin
          server.wait_for { ready? }
        rescue Excon::Errors::SocketError => ex
          puts "#{server.id} status check failed, retrying..."
          sleep 3
        else
          break
        end
      end
    end

  end
end
