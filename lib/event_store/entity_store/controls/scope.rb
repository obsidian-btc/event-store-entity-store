module EventStore
  module EntityStore
    module Controls
      module Scope

        class Valid < EventStore::EntityStore::Cache
          def self.valid_subject?(subject)
            true
          end
        end

        class Invalid < EventStore::EntityStore::Cache
          def self.valid_subject?(subject)
            false
          end
        end
      end
    end
  end
end
