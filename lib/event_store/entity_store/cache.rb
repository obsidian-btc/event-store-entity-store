module EventStore
  module EntityStore
    class Cache
      attr_reader :subject

      dependency :clock, Clock::UTC
      dependency :logger, Telemetry::Logger

      abstract :records
      abstract :reset

      def initialize(subject)
        @subject = subject
      end

      def self.configure(receiver, subject, scope: nil)
        instance = Factory.build_cache(subject, scope: scope)
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

      protected
      def self.build(subject)
        new(subject).tap do |instance|
          Clock::UTC.configure instance
          Telemetry::Logger.configure instance
        end
      end
    end
  end
end
