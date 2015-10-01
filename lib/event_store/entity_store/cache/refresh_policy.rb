module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        class Error < StandardError; end

        def self.included(mod)
          mod.extend UpdateCache
          mod.extend NewEntity
        end

        def self.!(*)
          raise Virtual::PureMethodError, '"!"'
        end

        def self.configure(receiver, policy_name)
          policy_class = policy_class(policy_name)
          receiver.refresh = policy_class
          policy_class
        end

        def self.policy_class(policy_name=nil)
          policy_name ||= Defaults::Name.get

          policy_class = policies[policy_name]

          unless policy_class
            error_msg = "Refresh policy \"#{policy_name}\" is unknown. It must be one of: immediate, none, or age."
            logger.error error_msg
            raise Error, error_msg
          end

          policy_class
        end

        def self.policies
          @policies ||= {
            immediate: Immediate,
            none: None,
            missing: Missing,
            age: Age
          }
        end

        def self.logger
          @logger ||= Telemetry::Logger.build self
        end

        module Defaults
          module Name
            def self.env_var_name
              'ENTITY_CACHE_REFRESH'
            end

            def self.env_var_value
              ENV[env_var_name]
            end

            def self.name
              'immediate'
            end

            def self.get
              name = env_var_value
              name ||= self.name
              name = name.to_sym

              name
            end
          end
        end

        module UpdateCache
          def update_cache(entity, id, cache, projection_class, stream_name, starting_position=nil)
            logger.trace "Updating cache (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity.class})"

            version = projection_class.! entity, stream_name, starting_position: starting_position

            projected = !!version

            cache_record = nil
            if projected
              cache_record = cache.put id, entity, version
            end

            logger.trace "Updated cache (ID: #{id}, Stream Name: #{stream_name}, Projection Class: #{projection_class}, Entity Class: #{entity.class})"

            cache_record
          end
        end

        module NewEntity
          def new_entity(entity_class)
            if entity_class.respond_to? :build
              return entity_class.build
            else
              return entity_class.new
            end
          end
        end
      end
    end
  end
end
