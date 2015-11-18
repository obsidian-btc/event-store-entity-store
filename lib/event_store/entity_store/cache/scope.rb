module EventStore
  module EntityStore
    class Cache
      module Scope
        class Error < StandardError; end

        module Defaults
          module Name
            def self.env_var_name
              'ENTITY_CACHE_SCOPE'
            end

            def self.env_var_value
              ENV[env_var_name]
            end

            def self.name
              'shared'
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
