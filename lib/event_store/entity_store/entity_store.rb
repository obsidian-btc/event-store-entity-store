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
      cls.send :dependency, :refresh, EntityStore::Cache::RefreshPolicy
      cls.send :dependency, :logger, Telemetry::Logger
      cls.send :virtual, :configure_dependencies
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
      def build(cache_scope: nil, refresh: nil)
        logger.trace "Building entity store"
        new.tap do |instance|
          EntityStore::Cache.configure instance, instance.entity_class, scope: cache_scope
          EntityStore::Cache::RefreshPolicy.configure instance, refresh
          Telemetry::Logger.configure instance
          instance.configure_dependencies
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

    def get(id, include: nil, refresh: nil)
      logger.trace "Getting entity (Class: #{entity_class}, ID: #{id}, Include: #{include})"

      cache_record = refresh_record(id, refresh)

      entity, version = nil
      unless cache_record.nil?
        entity = cache_record.entity
        version = cache_record.version
      end

      logger.debug "Get entity done: #{EntityStore::LogText.entity(entity)} (ID: #{id}, Version: #{EntityStore::LogText.version(version)}, Include: #{include})"

      if cache_record
        return cache_record.destructure(include)
      else
        return nil
      end
    end

    def get_version(id)
      _, version = get id, include: :version
      version
    end

    def refresh_record(id, policy_name=nil)
      if policy_name.nil?
        refresh_policy = refresh
      else
        refresh_policy = EntityStore::Cache::RefreshPolicy.policy_class(policy_name)
      end

      logger.trace "Refreshing cache record (ID: #{id}, Refresh Policy: #{refresh_policy})"

      stream_name = stream_name(id)

      cache_record = refresh_policy.! id, cache, projection_class, stream_name, entity_class

      logger.debug "Refreshed cache record (ID: #{id}, Refresh Policy: #{refresh_policy})"

      cache_record
    end

    module LogText
      def self.entity(entity)
        if entity.nil?
          return none
        else
          return entity.class.name
        end
      end

      def self.version(version)
        if version.nil?
          return none
        else
          return version
        end
      end

      def self.none
        "(none)"
      end
    end

    module Substitute
      def self.build
        Store.build refresh: :none
      end

      class Store
        include EventStore::EntityStore

        dependency :uuid, UUID::Random
        dependency :clock, Clock::Local

        category ' '
        entity Object
        projection Object

        def configure_dependencies
          UUID::Random.configure self
          Clock::Local.configure self
        end

        def add(id, entity, version=nil, time=nil)
          cache.put(id, entity, version, time)
        end

        def merge(entities)
          entities.is_a?(Array) and merge_entities(entities)
          entities.is_a?(Hash) and merge_records(entities)
        end

        def merge_entities(entities)
          entities.each do |entity|
            id = uuid.get
            add(id, entity)
          end
          nil
        end

        def merge_records(entities)
          entities.each do |id, entity|
            add(id, entity)
          end
          nil
        end
      end
    end
  end
end
