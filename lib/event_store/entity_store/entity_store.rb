module EventStore
  module EntityStore
    class Error < RuntimeError; end

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
      def configure(receiver, attr_name)
        instance = build
        receiver.send attr_name, instance
        instance
      end
    end

    def category_name=(val)
      @category_name = val
    end

    def get(id, include: nil, expected_version: nil, refresh: nil)
      logger.trace "Getting entity (Class: #{entity_class}, ID: #{id}, Include: #{include})"

      cache_record = refresh_record(id, refresh)

      entity, version = nil

      if cache_record
        entity = cache_record.entity
        version = cache_record.version
      end

      logger.debug "Get entity done: #{EntityStore::LogText.entity(entity)} (ID: #{id}, Version: #{EntityStore::LogText.version(version)}, Include: #{include})"

      unless expected_version.nil?
        EntityStore.assure_version(expected_version, version)
      end

      if cache_record
        return cache_record.destructure(include)
      else
        return Cache::Record::NoStream.destructure(include)
      end
    end

    def self.assure_version(expected_version, version)
      unless expected_version == version
        raise Error, "Expected version #{expected_version} is not the cached version #{version || '(nil)'}"
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

      cache_record = refresh_policy.(id, cache, projection_class, stream_name, entity_class)

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
        store = Store.build refresh: :none
        store.configure_dependencies
        store
      end

      class Store
        include EventStore::EntityStore

        dependency :uuid, Identifier::UUID::Random
        dependency :clock, Clock::Local

        category ' '
        entity Object
        projection Object

        def configure_dependencies
          Identifier::UUID::Random.configure self
          Clock::Local.configure self
        end

        def add(id, entity, version=nil, time=nil)
          time ||= clock.now
          logger.info time.inspect
          cache.put(id, entity, version, time)
        end

        def merge(entities, version=nil, time=nil)
          return merge_array(entities, version, time) if entities.is_a?(Array)
          return merge_hash(entities, version, time) if entities.is_a?(Hash)

          raise ArgumentError, "Merge does not support #{entities.class}"
        end

        def merge_array(entities, version=nil, time=nil)
          records = []
          entities.each do |entity|
            id = uuid.get
            records << add(id, entity, version, time)
          end
          records
        end

        def merge_hash(entities, version=nil, time=nil)
          records = []
          entities.each do |id, entity|
            records << add(id, entity, version, time)
          end
          records
        end
      end
    end
  end
end
