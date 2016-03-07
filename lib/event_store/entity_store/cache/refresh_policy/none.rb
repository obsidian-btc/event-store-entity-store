module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        module None
          def self.call(id, cache, projection_class, stream_name, entity_class, session=nil)
            logger.trace "Refreshing (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"

            cache.get(id).tap do |cache_record|
              logger.trace "Refreshed (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"
              logger.data "Cache Record: #{cache_record.inspect}"
            end
          end
          class << self; alias :! :call; end # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

          def self.logger
            @logger ||= Telemetry::Logger.get self
          end
        end
      end
    end
  end
end
