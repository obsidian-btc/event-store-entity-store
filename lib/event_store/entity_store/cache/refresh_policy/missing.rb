module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        module Missing
          def self.!(id, cache, projection_class, stream_name, entity_class)
            cache.get id
          end
        end
      end
    end
  end
end
