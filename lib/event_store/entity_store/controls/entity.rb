module EventStore
  module EntityProjection
    module Controls
      module Entity
        class SomeEntity
          include Schema::DataStructure

          attribute :some_attribute
          attribute :some_time
        end

        def self.example
          SomeEntity.build
        end
      end
    end
  end
end
