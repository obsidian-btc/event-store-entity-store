module EventStore
  module EntityStore
    module Controls
      module Store
        def self.category
          'someEntity'
        end

        class SomeStore
          include EventStore::EntityStore

          category Controls::Store.category
          entity Controls::Entity.entity_class
          projection Controls::Projection::SomeProjection
        end

        def self.example
          SomeStore.build
        end
      end
    end
  end
end
