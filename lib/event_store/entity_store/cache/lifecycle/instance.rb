module EventStore
  module EntityStore
    class Cache
      module Lifecycle
        class Instance < Cache
          def records
            @records ||= reset
          end

          def reset
            @records = {}
          end
        end
      end
    end
  end
end
