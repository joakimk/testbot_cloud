require 'fog'
require 'yaml'
require 'active_support/core_ext/hash/keys'
require File.expand_path(File.join(File.dirname(__FILE__), 'server/factory.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'servers.rb'))

module TestbotCloud
  class Cluster

    def initialize
      Fog.mock! if ENV['INTEGRATION_TEST']
      if project?
        load_config

        @compute = Fog::Compute.new(@provider_config)
      end
    end

    def start
      project? || return
      
      puts "Starting #{@runner_count} runners..."
      for_each_runner_in_a_thread do |mutex|
        server = nil
        with_retries("server creation") do
          mutex.synchronize {
            server = @compute.servers.create(@runner_config) 
            Servers.log_creation(server)
          }
        end
        
        puts "#{server.id} is being created..."
        with_retries("#{server.id} ready check") do
          server.wait_for { ready? }          
        end

        puts "#{server.id} is up, installing testbot..."
        with_retries("testbot installation") do
          if Server::Factory.create(@compute, @opts, server).bootstrap!(mutex)
            puts "#{server.id} ready."
          else
            puts "#{server.id} failed, shutting down."
            server.destroy
            Servers.log_destruction(server)
          end
        end
      end
    end

    def stop
      project? || return

      @compute.servers.each do |server|
        if Servers.known?(server) && server.ready?
          puts "Shutting down #{server.id}..."
          with_retries("server destruction") do
            server.destroy
          end
          Servers.log_destruction(server)
        end
      end
    end

    private

    def project?
      File.exists?("config.yml")
    end

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
      @opts = { :ssh_user => config["ssh_user"] }
    end

    def with_retries(job)
      5.times do
        begin
          yield
        rescue Excon::Errors::SocketError => ex
          puts "#{job} failed, retrying..."
          sleep 3
        else
          break
        end
      end
    end

  end
end
