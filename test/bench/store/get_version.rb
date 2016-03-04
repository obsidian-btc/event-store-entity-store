require_relative './store_init'

context "Get Version" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  category_name = stream_name.split('-')[0]

  store = EventStore::EntityStore::Controls::Store::SomeStore.build
  store.category_name = category_name

  test "Gets the version number of identified entity (applying the cache refresh policy that is in-effect)" do
    version = store.get_version id
    assert(version == 1)
  end
end
