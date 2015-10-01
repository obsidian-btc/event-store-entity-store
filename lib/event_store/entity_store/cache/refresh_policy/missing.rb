module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        module Missing
          include RefreshPolicy

          def self.!(id, cache, projection_class, stream_name, entity_class)
            refresh(id, cache, projection_class, stream_name, entity_class) do |cache_record|
              unless cache_record
                entity = new_entity(entity_class)
                cache_record = update_cache(entity, id, cache, projection_class, stream_name)
              end
            end
          end

          # def self.!(id, cache, projection_class, stream_name, entity_class)
          #   logger.trace "Refreshing (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"

          #   cache_record = cache.get(id)

          #   unless cache_record
          #     entity = new_entity(entity_class)
          #     cache_record = update_cache(entity, id, cache, projection_class, stream_name)
          #   end

          #   logger.trace "Refreshed (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity_class})"
          #   logger.data "Cache Record: #{cache_record.inspect}"

          #   cache_record
          # end

          def self.logger
            @logger ||= Telemetry::Logger.get self
          end
        end
      end
    end
  end
end
