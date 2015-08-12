module EventStore
  module EntityStore
    module Store
      def self.included(cls)
        cls.extend EntityMacro
        cls.extend ProjectionMacro
        cls.extend Logger
        cls.extend Build

        cls.send :include, EventStore::Messaging::StreamName
        cls.send :dependency, :logger, Telemetry::Logger
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

      module Logger
        def logger
          @logger ||= Telemetry::Logger.build self
        end
      end

      module Build
        def build
          logger.trace "Building entity store"
          new.tap do |instance|
            Telemetry::Logger.configure instance
            logger.debug "Built entity store (Entity Class: #{instance.entity_class}, Category Name: #{instance.category_name}, Projection Class: #{instance.projection_class})"
          end
        end
      end

      def category_name=(val)
        @category_name = val
      end

      def get(id)
        logger.trace "Getting entity (Class: #{entity_class}, ID: #{id})"
        entity = get_entity(id)
        stream_name = stream_name(id)

        projection_class.! entity, stream_name

        logger.trace "Got entity: #{Store.entity_log_msg(entity)}"

        entity
      end

      def get_entity(id)
        new_entity
      end

      def self.entity_log_msg(entity)
        if entity.nil?
          return "(none)"
        else
          return entity.class.name
        end
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
