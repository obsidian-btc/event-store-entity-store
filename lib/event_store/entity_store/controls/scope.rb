module EventStore
  module EntityStore
    module Controls
      module Scope
        class ReadableAndWritable < EventStore::EntityStore::Cache::Scope::Exclusive
          def self.readable?(subject)
            true
          end

          def self.writable?(subject)
            true
          end
        end

        class NotReadableNotWritable < EventStore::EntityStore::Cache::Scope::Exclusive
          def self.readable?(subject)
            false
          end

          def self.writable?(subject)
            false
          end
        end

        class ReadableNotWritable < EventStore::EntityStore::Cache::Scope::Exclusive
          def self.readable?(subject)
            true
          end

          def self.writable?(subject)
            false
          end
        end

        class WritableNotReadable < EventStore::EntityStore::Cache::Scope::Exclusive
          def self.readable?(subject)
            false
          end

          def self.writable?(subject)
            true
          end
        end
      end
    end
  end
end
