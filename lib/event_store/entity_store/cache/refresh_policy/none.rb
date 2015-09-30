module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        module None
          def self.!(id, cache, projection_class, stream_name, entity_class)
            logger.trace "Refreshing (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"

            cache.get(id).tap do |cache_record|
              logger.trace "Refreshed (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"
              logger.data "Cache Record: #{cache_record.inspect}"
            end
          end

          def self.logger
            @logger ||= Telemetry::Logger.get self
          end
        end
      end
    end
  end
end
