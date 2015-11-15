module EventStore
  module EntityStore
    class Cache
      class Record
        class Error < RuntimeError; end

        attr_reader :entity
        attr_reader :id
        attr_reader :version
        attr_reader :time

        def initialize(entity, id, version, time)
          @entity = entity
          @id = id
          @version = version
          @time = time
        end

        def destructure(includes=nil)
          includes ||= []
          includes = [includes] unless includes.is_a? Array

          responses = []
          includes.each do |attribute|
            value = send(attribute)

            if attribute == :version && value.nil?
              value = NoStream.version
            end

            responses << value
          end

          if responses.empty?
            return entity
          else
            return responses.unshift(entity)
          end
        end

        module NoStream
          def self.destructure(includes=nil)
            nil_record = Record.new(nil, nil, nil, nil)
            nil_record.destructure(includes)
          end

          def self.version
            :no_stream
          end
        end

        def age
          Clock::UTC.elapsed_milliseconds(time, Clock::UTC.now)
        end

        def assure_version(expected_version)
          unless expected_version == version
            raise Error, "Expected version #{expected_version} is not the cached version #{version}"
          end
        end

        def logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
