module EventStore
  module EntityStore
    class Cache
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
