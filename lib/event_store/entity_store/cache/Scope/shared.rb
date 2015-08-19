module EventStore
  module EntityStore
    class Cache
      module Scope
        class Shared < Cache
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
