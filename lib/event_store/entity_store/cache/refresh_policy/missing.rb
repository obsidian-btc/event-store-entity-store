module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        module Missing
          def self.!(id, cache, projection_class, stream_name, entity_class)
            logger.trace "Refreshing (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"

            cache_record = cache.get(id)

            unless cache_record
              entity = new_entity(entity_class)
              cache_record = update_cache(entity, id, cache, projection_class, stream_name)
            end

            logger.trace "Refreshed (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"
            logger.data "Cache Record: #{cache_record.inspect}"

            cache_record
          end

          def self.update_cache(entity, id, cache, projection_class, stream_name, starting_position=nil)
            logger.trace "Updating cache (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity.class})"

            version = projection_class.! entity, stream_name, starting_position: starting_position

            projected = !!version

            cache_record = nil
            if projected
              cache_record = cache.put id, entity, version
            end

            logger.trace "Updated cache (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity.class})"

            cache_record
          end

          def self.new_entity(entity_class)
            if entity_class.respond_to? :build
              return entity_class.build
            else
              return entity_class.new
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
