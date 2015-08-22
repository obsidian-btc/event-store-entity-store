module EventStore
  module EntityStore
    class Cache
      module Scope
        class Exclusive < Cache
          def records
            @records ||= {}
          end
        end
      end
    end
  end
end
