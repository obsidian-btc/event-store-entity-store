require_relative '../store_init'

require_relative '../store_init'

context "Get Entity Using the Immediate Refresh Policy" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  store = EventStore::EntityStore::Controls::Store::SomeStore.build refresh: :immediate
  category_name = stream_name.split('-')[0]
  store.category_name = category_name

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)

  cache = store.cache

  entity = EventStore::EntityStore::Controls::Entity.new
  entity.some_attribute = EventStore::EntityStore::Controls::Message.attribute

  initial_cache_record = cache.put id, entity, 0

  retrieved_entity, version, time = store.get id, include: [:version, :time]

  context "Cache is refreshed" do
    test "Entity" do
      assert(!entity.nil?)
    end

    test "Version is updated" do
      assert(version != initial_cache_record.version)
    end

    test "Time is updated" do
      assert(time != initial_cache_record.time)
    end
  end
end
