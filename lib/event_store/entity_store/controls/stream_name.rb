module EventStore
  module EntityStore
    module Controls
      module StreamName
        def self.id(stream_name)
          EventStore::Messaging::StreamName.get_id(stream_name)
        end

        def self.get(category=nil, id=nil, random: nil)
          EventStore::EntityProjection::Controls::StreamName.get category, id, random: random
        end
      end
    end
  end
end
