module EventStore
  module EntityProjection
    module Controls
      module StreamName
        def self.get(category=nil, id=nil, random: nil)
          EventStore::Client::HTTP::Controls::StreamName.get category, id, random: random
        end
      end
    end
  end
end
