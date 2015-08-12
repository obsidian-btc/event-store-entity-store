module EventStore
  module EntityStore
    module Controls
      module Store
        def self.category
          'someEntity'
        end

        class SomeStore
          include EntityStore::Store

          category Controls::Store.category
          entity Controls::Entity.entity_class
          projection Controls::Projection::SomeProjection

          # def projection(id, entity)
          #   stream_name = stream_name(id)
          #   # Projection.build(entity, stream_name, starting_position: nil, slice_size: nil)
          #   Projection.build(entity, stream_name)
          # end

        end

        def self.example
          SomeStore.build
        end
      end
    end
  end
end
