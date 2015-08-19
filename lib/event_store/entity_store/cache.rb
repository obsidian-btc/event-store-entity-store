module EventStore
  module EntityStore
    class Cache
      dependency :clock, Clock::UTC
      dependency :logger, Telemetry::Logger

      abstract :records
      abstract :reset

      def self.build
        scope = :instance
        scope_class(scope).new.tap do |instance|
          Clock::UTC.configure instance
          Telemetry::Logger.configure instance
        end
      end

      def self.scope_class(scope_name)
        if scope_name == :instance
          return Scope::Instance
        end

        # raise if not in list
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

        record = Record.new entity, id, version, time
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
        @logger ||= Telemetry::Logger.build
      end

      Record = Struct.new(:entity, :id, :version, :time) do
        def age
          Clock::UTC.elapsed_milliseconds(time, Clock::UTC.now)
        end

        def destructure(includes=nil)
          includes ||= []
          includes = [includes] unless includes.is_a? Array

          responses = []
          includes.each do |attribute|
            responses << send(attribute)
          end

          if responses.empty?
            return entity
          else
            return responses.unshift(entity)
          end
        end

        def logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
