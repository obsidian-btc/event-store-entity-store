module EventStore
  module EntityStore
    module Controls
      module Record
        def self.example
          Cache::Record.new(Controls::Entity.example, 11, ::Controls::Time.reference)
        end
      end
    end
  end
end
