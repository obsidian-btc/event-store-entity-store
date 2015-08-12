module EventStore
  module EntityStore
    class Cache
      dependency :logger, Telemetry::Logger

      def entities
        @entities ||= {}
      end

      def self.build
        new.tap do |instance|
          Telemetry::Logger.configure instance
        end
      end

      def self.configure(receiver)
        instance = build
        receiver.cache = instance
        instance
      end

      def get(id)
        logger.trace "Getting entity from cache (ID: #{id})"
        entities[id].tap do |entity|
          logger.debug "Got entity: #{self.class.entity_log_msg(entity)} (ID: #{id})"
        end
      end

      def put(id, entity)
        entities[id] = entity
      end

      def self.entity_log_msg(entity)
        if entity.nil?
          return "(none)"
        else
          return entity.class.name
        end
      end

      def self.logger
        @logger ||= Telemetry::Logger.build
      end
    end
  end
end
