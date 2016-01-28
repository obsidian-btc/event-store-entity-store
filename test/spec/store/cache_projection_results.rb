require_relative 'store_init'

context "Cache Projection Results" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  category_name = stream_name.split('-')[0]

  store = EventStore::EntityStore::Controls::Store::SomeStore.build

  store.category_name = category_name

  store.get id

  cached_entity = store.cache.get id

  test "Projected entity is cached" do
    assert(!cached_entity.nil?)
  end
end
