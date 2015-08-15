module EventStore
  module EntityStore
    def self.included(cls)
      cls.extend EntityMacro
      cls.extend ProjectionMacro
      cls.extend Logger
      cls.extend Configure
      cls.extend Build

      cls.send :include, EventStore::Messaging::StreamName
      cls.send :dependency, :cache, EntityStore::Cache
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
          EntityStore::Cache.configure instance
          Telemetry::Logger.configure instance
          logger.debug "Built entity store (Entity Class: #{instance.entity_class}, Category Name: #{instance.category_name}, Projection Class: #{instance.projection_class})"
        end
      end
    end

    module Configure
      def configure(receiver)
        instance = build
        receiver.store = instance
        instance
      end
    end

    def category_name=(val)
      @category_name = val
    end

    def get(id, include: nil, cache_only: nil)
      include ||= []
      cache_only ||= false

      logger.trace "Getting entity (Class: #{entity_class}, ID: #{id}, Cache Only: #{cache_only})"

      stream_name = stream_name(id)

      record = cache.get(id)

      entity = nil
      starting_position = nil
      unless record.nil?
        entity = record.entity
        starting_position = record.version + 1
      end

      # this is: update_entity(entity)
      # - returns version
      version = nil
      unless cache_only
        projected_entity = (entity || new_entity)
        version = projection_class.! projected_entity, stream_name, starting_position: starting_position

        if version
          entity = projected_entity
          cache.put id, entity, version
        end
      end


      logger.debug "Got entity: #{EntityStore.entity_log_msg(entity)} (ID: #{id}, Version: #{version}, Cache Only: #{cache_only})"

      entity
    end

    def update
      raise NotImplementedError
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
