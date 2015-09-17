module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        module Immediate
          def self.!(id, cache, projection_class, stream_name, entity_class)
            logger.trace "Refreshing (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"

            cache_record = cache.get(id)

            entity = nil
            starting_position = nil
            if cache_record
              entity = cache_record.entity
              starting_position = cache_record.version + 1
            else
              entity = new_entity(entity_class)
            end

            version = projection_class.! entity, stream_name, starting_position: starting_position

            got_entity = !!version

            if got_entity
              new_cache_record = cache.put id, entity, version
            else
              new_cache_record = Cache::Record.new
            end

            logger.trace "Refreshed (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"

            new_cache_record
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
