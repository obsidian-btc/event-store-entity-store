module EventStore
  module EntityStore
    module Controls
      module Entity
        def self.example
          EventStore::EntityProjection::Controls::Entity.example
        end

        def self.entity_class
          EventStore::EntityProjection::Controls::Entity::SomeEntity
        end

        def self.new
          entity_class.new
        end
      end
    end
  end
end
