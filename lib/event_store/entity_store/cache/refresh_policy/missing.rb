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
                cache_record
              end
            end
          end
        end
      end
    end
  end
end
