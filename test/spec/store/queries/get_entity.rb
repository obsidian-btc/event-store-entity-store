require_relative '../store_init'

describe "Get Entity from Store" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  category_name = stream_name.split('-')[0]

  store = EventStore::EntityStore::Controls::Store::SomeStore.build

  store.category_name = category_name

  entity = store.get id

  describe "Entity Attributes" do
    specify "some_attribute" do
      assert(entity.some_attribute == EventStore::EntityStore::Controls::Message.attribute)
    end

    specify "some_time" do
      assert(entity.some_time == EventStore::EntityStore::Controls::Message.time)
    end
  end
end
