module EventStore
  module EntityStore
    module Controls
      module Entity
        def self.example
          entity = EventStore::EntityProjection::Controls::Entity.example

          entity.some_attribute = Controls::Message.attribute
          entity.some_time = Controls::Message.time

          entity
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
