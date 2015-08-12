module EventStore
  module EntityStore
    class Cache
      dependency :logger, Telemetry::Logger

      def items
        @items ||= {}
      end

      def self.build
        new.tap do |instance|
          Telemetry::Logger.configure instance
        end
      end

      def get(id)
        items[id]
      end

      def put(id, entity)
        items[id] = entity
      end

      def self.logger
        @logger ||= Telemetry::Logger.build
      end
    end
  end
end
