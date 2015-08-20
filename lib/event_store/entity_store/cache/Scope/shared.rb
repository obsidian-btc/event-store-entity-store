module EventStore
  module EntityStore
    class Cache
      module Scope
        class Shared < Cache
          def records
            self.class.records(subject)
          end

          def reset
            self.class.records_registry[subject] = {}
          end

          def self.records(subject)
            records_registry[subject] ||= {}
          end

          def self.records_registry
            @records_registry ||= {}
          end
        end
      end
    end
  end
end
