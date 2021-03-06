require_relative '../store_init'

context "Get Entity Using the Missing Refresh Policy" do
  EventStore::EntityStore::Cache::RefreshPolicy.policies[:missing] = EventStore::EntityStore::Cache::RefreshPolicy::Missing

  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  store = EventStore::EntityStore::Controls::Store::SomeStore.build refresh: :missing
  category_name = stream_name.split('-')[0]
  store.category_name = category_name

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)

  cache = store.cache

  entity, version = store.get id, include: :version

  context "Cache is refreshed" do
    test "Entity" do
      assert(!entity.nil?)
    end

    test "Version is updated" do
      assert(version == 1)
    end
  end
end
