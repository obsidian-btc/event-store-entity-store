module EventStore
  module EntityStore
    class Cache
      module Factory
        def self.build_cache(subject, scope: nil)
          scope ||= Scope::Defaults::Name.get

          scope_class(scope).build(subject)
        end

        def self.scope_class(scope_name)
          scope_class = scopes[scope_name]

          unless scope_class
            error_msg = "Scope \"#{scope_name}\" is unknown. It must be one of: #{scopes.keys.join(', ')}."
            logger.error error_msg
            raise Scope::Error, error_msg
          end

          scope_class
        end

        def self.scopes
          @scopes ||= {
            exclusive: Scope::Exclusive,
            shared: Scope::Shared
          }
        end

        def self.logger
          @logger ||= Telemetry::Logger.build self
        end
      end
    end
  end
end
