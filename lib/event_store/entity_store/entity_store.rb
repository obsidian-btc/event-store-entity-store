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
      def build(cache_scope: nil)
        logger.trace "Building entity store"
        new.tap do |instance|
          EntityStore::Cache.configure instance, instance.entity_class, scope: cache_scope
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

    def get(id, include: nil)
      logger.trace "Getting entity (Class: #{entity_class}, ID: #{id})"

      cache_record = cache.get(id)

      cache_record = update_entity(cache_record, id)

      entity = cache_record.entity
      version = cache_record.version

      logger.debug "Get entity done: #{EntityStore.entity_log_msg(entity)} (ID: #{id}, Version: #{version})"

      cache_record.destructure(include)
    end

    def update_entity(cache_record, id)
      stream_name = stream_name(id)

      refresh = EventStore::EntityStore::Cache::RefreshPolicy::Immediate
      refresh.! id, cache, projection_class, stream_name, entity_class
    end

    # TODO Remove once cache refresh policies are implemented [Scott, Thu Sep 03 2015]
    # def update_entity(cache_record, id)
    #   stream_name = stream_name(id)

    #   entity = nil
    #   starting_position = nil

    #   if cache_record
    #     entity = cache_record.entity
    #     starting_position = cache_record.version + 1
    #   else
    #     entity = new_entity
    #   end

    #   version = projection_class.! entity, stream_name, starting_position: starting_position

    #   got_entity = !!version

    #   if got_entity
    #     cache_record = cache.put id, entity, version
    #   else
    #     cache_record = Cache::Record.new
    #   end

    #   cache_record
    # end

    # def new_entity
    #   if entity_class.respond_to? :build
    #     return entity_class.build
    #   else
    #     return entity_class.new
    #   end
    # end

    def self.entity_log_msg(entity)
      if entity.nil?
        return "(none)"
      else
        return entity.class.name
      end
    end
  end
end
