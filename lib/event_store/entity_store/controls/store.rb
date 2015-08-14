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

        module Anomaly
          module StreamDoesntExist
            class SomeStore
              include EventStore::EntityStore

              category 'doesntExist'
              entity Controls::Entity.entity_class
              projection Controls::Projection::SomeProjection
            end
          end
        end
      end
    end
  end
end
