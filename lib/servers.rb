module TestbotCloud
  class Servers
    def self.log_creation(server)
      FileUtils.mkdir_p ".servers/#{server.id}"
    end

    def self.known?(server)
      File.exists? ".servers/#{server.id}"
    end

    def self.log_destruction(server)
      FileUtils.rm_rf ".servers/#{server.id}"
    end
  end
end
