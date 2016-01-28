require_relative '../store_init'

context "Get Entity Using the None Refresh Policy" do
  EventStore::EntityStore::Cache::RefreshPolicy.policies[:none] = EventStore::EntityStore::Cache::RefreshPolicy::None

  store = EventStore::EntityStore::Controls::Store::SomeStore.build refresh: :none

  id = ::Controls::ID.get

  cache = store.cache

  entity = EventStore::EntityStore::Controls::Entity.new

  initial_cache_record = cache.put id, entity, 0

  retrieved_entity, version, time = store.get id, include: [:version, :time]

  context "Cache is not refreshed" do
    test "Entity" do
      assert(retrieved_entity.object_id == entity.object_id)
    end

    test "Version is not changed" do
      assert(version == initial_cache_record.version)
    end

    test "Time is not changed" do
      assert(time == initial_cache_record.time)
    end
  end
end
