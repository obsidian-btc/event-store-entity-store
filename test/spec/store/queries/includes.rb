require_relative '../store_init'

describe "Get Including ID" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  category_name = stream_name.split('-')[0]

  store = EventStore::EntityStore::Controls::Store::SomeStore.build

  store.category_name = category_name

  describe "Returns" do
    retrieved_entity, retrieved_id = store.get id, include: :id

    specify "ID" do
      assert(retrieved_id == id)
    end

    describe "Entity" do
      specify "some_attribute" do
        assert(retrieved_entity.some_attribute == EventStore::EntityStore::Controls::Message.attribute)
      end

      specify "some_time" do
        assert(retrieved_entity.some_time == EventStore::EntityStore::Controls::Message.time)
      end
    end
  end
end
