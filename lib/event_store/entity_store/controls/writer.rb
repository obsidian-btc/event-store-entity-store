module EventStore
  module EntityProjection
    module Controls
      module Writer
        def self.write(count=nil, stream_name=nil)
          count ||= 1

          stream_name = Controls::StreamName.get stream_name
          path = "/streams/#{stream_name}"

          writer = EventStore::Messaging::Writer.build

          messages = Controls::Message.examples

          count.times do |i|
            writer.write messages, stream_name
          end

          stream_name
        end
      end
    end
  end
end
