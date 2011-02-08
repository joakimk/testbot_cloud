module TestbotCloud
  module Network
    class Brightbox
      def initialize(server)
      end

      def bootstrap!
      end
    end

    class Factory
      def self.create(server)
        Brightbox.new(server)  
      end
    end
  end
end
