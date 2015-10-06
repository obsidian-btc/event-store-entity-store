module EventStore
  module EntityStore
    class Cache
      Record = Struct.new(:entity, :id, :version, :time) do
        class Error < RuntimeError; end

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
