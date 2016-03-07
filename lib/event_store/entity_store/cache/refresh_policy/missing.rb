module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        module Missing
          include RefreshPolicy

          def self.call(id, cache, projection_class, stream_name, entity_class, session=nil)
            refresh(id, cache, projection_class, stream_name, entity_class) do |cache_record|
              unless cache_record
                entity = new_entity(entity_class)
                cache_record = update_cache(entity, id, cache, projection_class, stream_name, session: session)
                cache_record
              end
            end
          end
          class << self; alias :! :call; end # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]
        end
      end
    end
  end
end
