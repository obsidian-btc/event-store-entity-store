module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        module Missing
          def self.!(id, cache, projection_class, stream_name, entity_class)
            logger.trace "Refreshing (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"

            entity, version = get_entity(id, cache, entity_class)



            unless cache_record
              cache_record = update_cache(id, cache, projection_class, stream_name, entity_class)
            end

            logger.trace "Refreshed (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"
            logger.data "Cache Record: #{cache_record.inspect}"

            cache_record
          end

          def self.get_entity(id, cache, entity_class)
            cache_record = cache.get(id)

            unless cache_record
              entity = new_entity(entity_class)
              version = nil
            else
              entity = cache_record.entity
              version = cache_record.version
            end

            return entity, version
          end



          def self.update_cache(id, cache, projection_class, stream_name, entity_class)
            logger.trace "Updating cache (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"

            entity = new_entity(entity_class)


            version = projection_class.! entity, stream_name

            projected = !!version

            cache_record = nil
            if projected
              cache_record = cache.put id, entity, version
            end

            logger.trace "Updated cache (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"

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
