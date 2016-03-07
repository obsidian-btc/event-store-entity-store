module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        module Immediate
          include RefreshPolicy

          def self.call(id, cache, projection_class, stream_name, entity_class, session=nil)
            refresh(id, cache, projection_class, stream_name, entity_class) do |cache_record|
              unless cache_record
                entity = new_entity(entity_class)
                starting_position = nil
              else
                entity = cache_record.entity
                starting_position = cache_record.version + 1
              end

              updated_cache_record = update_cache(entity, id, cache, projection_class, stream_name, starting_position, session: session)
              updated_cache_record || cache_record
            end
          end
          class << self; alias :! :call; end # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]
        end
      end
    end
  end
end
