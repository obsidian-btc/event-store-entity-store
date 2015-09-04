module EventStore
  module EntityStore
    class Cache
      module RefreshPolicy
        def self.!
          raise Virtual::PureMethodError, '"!"'
        end

        def self.configure(receiver, policy_name)
          policy_class = policy_class(policy_name)
          receiver.refresh = policy_class
          policy_class
        end

        def self.policy_class(policy_name)
          policy_name ||= Defaults::Name.get
          send policy_name
        end

        def self.immediate
          Immediate
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
      end
    end
  end
end
