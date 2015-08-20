module EventStore
  module EntityStore
    class Cache
      dependency :clock, Clock::UTC
      dependency :logger, Telemetry::Logger

      abstract :records
      abstract :reset

      def self.scopes
        @scopes ||= {
          exclusive: Scope::Exclusive,
          shared: Scope::Shared
        }
      end

      def self.build(scope: nil)
        scope ||= Scope::Defaults::Name.get

        scope_class(scope).new.tap do |instance|
          Clock::UTC.configure instance
          Telemetry::Logger.configure instance
        end
      end

      def self.scope_class(scope_name)
        scope_class = scopes[scope_name]

        unless scope_class
          error_msg = "Scope \"#{scope_name}\" is unknown. It must be one of: #{scopes.keys.join(', ')}."
          logger.error error_msg
          raise Scope::Error, error_msg
        end

        scope_class
      end

      def self.configure(receiver)
        instance = build
        receiver.cache = instance
        instance
      end

      def put(id, entity, version=nil, time=nil)
        version ||= 0
        time ||= clock.iso8601

        logger.trace "Putting record into cache (ID: #{id}, Entity Class: #{entity.class.name}, Version: #{version}, Time: #{time})"

        record = Record.new(entity, id, version, time)
        records[id] = record

        logger.debug "Put record into cache (ID: #{id}, Entity Class: #{entity.class.name}, Version: #{version}, Time: #{time})"

        record
      end

      def get(id)
        logger.trace "Getting record from cache (ID: #{id})"

        record = records[id]

        unless record.nil?
          logger.debug "Cache hit: #{self.class.object_log_msg(record)} (ID: #{id})"
        else
          logger.debug "Cache miss (ID: #{id})"
        end

        record
      end

      def self.object_log_msg(object)
        if object.nil?
          return "(none)"
        else
          return object.class.name
        end
      end

      def self.logger
        @logger ||= Telemetry::Logger.build self
      end
    end
  end
end
