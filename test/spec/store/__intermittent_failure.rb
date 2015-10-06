require_relative './store_init'

describe "Intermittent Failure" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  category_name = stream_name.split('-')[0]

  store = EventStore::EntityStore::Controls::Store::SomeStore.build
  store.category_name = category_name

  specify "Get" do
    assert_raises(EventStore::EntityStore::Cache::Error) do
      store.get id, expected_version: 11
    end
  end

  specify "Get" do
    assert_raises(EventStore::EntityStore::Cache::Error) do
      store.get id, expected_version: 11
    end
  end
end
