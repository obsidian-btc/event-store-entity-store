require_relative './store_init'

describe "Get with Expected Version" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  category_name = stream_name.split('-')[0]

  store = EventStore::EntityStore::Controls::Store::SomeStore.build
  store.category_name = category_name

  context "Right version" do
    specify "Is not an error" do
      store.get id, expected_version: 1
    end
  end

  context "Wrong version" do
    specify "Is an error" do
      assert_raises(EventStore::EntityStore::Cache::Error) do
        store.get id, expected_version: 11
      end
    end
  end
end
