module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        module None
          def self.!(id, cache, projection_class, stream_name, entity_class)
          end
        end
      end
    end
  end
end
