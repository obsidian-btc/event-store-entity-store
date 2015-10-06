module EventStore
  module EntityStore
    class Cache
      class InvalidSubjectError < RuntimeError; end

      attr_reader :subject

      dependency :clock, Clock::UTC
      dependency :logger, Telemetry::Logger

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
        time ||= clock.now

        logger.trace "Putting record into cache (ID: #{id}, Entity Class: #{entity.class.name}, Version: #{version}, Time: #{time})"

        self.class.validate_writable(entity.class)

        record = Record.new(entity, id, version, time)
        put_record(id, record)

        logger.debug "Put record into cache (ID: #{id}, Entity Class: #{entity.class.name}, Version: #{version}, Time: #{time})"

        record
      end

      def put_record(id, record)
        records[id] = record
      end

      def get(id)
        logger.trace "Getting record from cache (ID: #{id})"

        self.class.validate_readable(subject)

        record = get_record(id)

        unless record.nil?
          logger.debug "Cache hit: #{self.class.object_log_msg(record)} (ID: #{id})"
        else
          logger.debug "Cache miss (ID: #{id})"
        end

        record
      end

      def get_record(id)
        records[id]
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

      protected
      def self.build(subject)
        validate_subject(subject)

        new(subject).tap do |instance|
          Clock::UTC.configure instance
          Telemetry::Logger.configure instance
          instance.configure_dependencies
        end
      end

      def self.validate_subject(subject)
        validate_readable(subject)
        validate_writable(subject)
      end

      def self.validate_readable(subject)
        raise InvalidSubjectError unless readable?(subject)
      end

      def self.validate_writable(subject)
        raise InvalidSubjectError unless writable?(subject)
      end

      class << self
        virtual :readable? do |subject|
          true
        end

        virtual :writable? do |subject|
          true
        end
      end

      virtual :configure_dependencies
    end
  end
end
