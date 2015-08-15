require_relative '../store_init'

describe "Get Entity, Cache Only" do
  stream_name = EventStore::EntityStore::Controls::StreamName.get 'someEntity'
  store = EventStore::EntityStore::Controls::Store::SomeStore.build
  category_name = stream_name.split('-')[0]
  store.category_name = category_name

  EventStore::EntityStore::Controls::Writer.write_first stream_name

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)

  entity = store.get id

  describe "Entity Attributes" do
    EventStore::EntityStore::Controls::Writer.write_second stream_name

    retrieved_entity = store.get id, cache_only: true

    specify "some_attribute" do
      assert(entity.some_attribute == EventStore::EntityStore::Controls::Message.attribute)
    end

    specify "some_time" do
      assert(entity.some_time.nil?)
    end
  end
end
