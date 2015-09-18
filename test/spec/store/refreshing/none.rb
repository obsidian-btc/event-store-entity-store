require_relative '../store_init'

describe "Get Entity Using the None Refresh Policy" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  store = EventStore::EntityStore::Controls::Store::SomeStore.build refresh: :none
  category_name = stream_name.split('-')[0]
  store.category_name = category_name

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)

  cache = store.cache

  entity = EventStore::EntityStore::Controls::Entity.new

  initial_cache_record = cache.put id, entity, 0

  retrieved_entity, version, time = store.get id, include: [:version, :time]

  describe "Entity is not refreshed" do
    specify "Entity" do
      assert(retrieved_entity.object_id == entity.object_id)
    end

    specify "Version is not changed" do
      assert(version == initial_cache_record.version)
    end

    specify "Time is not changed" do
      assert(time == initial_cache_record.time)
    end
  end
end
