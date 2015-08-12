module EventStore
  module EntityStore
    module Controls
      module StreamName
        def self.id(stream_name)
          EventStore::Messaging::StreamName.get_id(stream_name)
        end
      end
    end
  end
end
