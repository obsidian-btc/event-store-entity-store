module EventStore
  module EntityStore
    module Controls
      module Entity
        def self.example
          EventStore::EntityProjection::Controls::Entity.example
        end

        def self.new
          EventStore::EntityProjection::Controls::Entity::SomeEntity.new
        end
      end
    end
  end
end
