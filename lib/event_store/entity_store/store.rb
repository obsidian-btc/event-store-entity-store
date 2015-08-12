module EventStore
  module EntityStore
    module Store
      def self.included(cls)
        cls.extend EntityMacro
        cls.extend ProjectionMacro
        cls.extend Build

        cls.send :include, EventStore::Messaging::StreamName
      end

      module EntityMacro
        def entity_macro(cls)
          self.send :define_method, :entity_class do
            cls
          end
        end
        alias :entity :entity_macro
      end

      module ProjectionMacro
        def projection_macro(cls)
          self.send :define_method, :projection_class do
            cls
          end
        end
        alias :projection :projection_macro
      end

      module Build
        def build
          new
        end
      end

      def category_name=(val)
        @category_name = val
      end

      def get(id)
        entity = get_entity(id)
        stream_name = stream_name(id)
        projection = projection(entity, stream_name)
        entity
      end

      def projection(entity, stream_name)
        projection_class.! entity, stream_name
      end

      def get_entity(id)
        new_entity
      end

      def new_entity
        if entity_class.respond_to? :build
          return entity_class.build
        else
          return entity_class.new
        end
      end
    end
  end
end
