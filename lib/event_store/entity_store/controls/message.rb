module EventStore
  module EntityProjection
    module Controls
      module Message
        class SomeMessage
          include EventStore::Messaging::Message

          attribute :some_attribute
        end

        class OtherMessage
          include EventStore::Messaging::Message

          attribute :some_time
        end

        def self.attribute
          'some value'
        end

        def self.time(time=nil)
          time || ::Controls::Time.reference
        end

        def self.example
          msg = SomeMessage.new
          msg.some_attribute = attribute

          msg
        end

        def self.examples
          msg_1 = SomeMessage.new
          msg_1.some_attribute = attribute

          msg_2 = OtherMessage.new
          msg_2.some_time = time

          [msg_1, msg_2]
        end
      end
    end
  end
end
