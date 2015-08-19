require_relative '../cache_init'

describe "Shared Cache Scope" do
  specify "List of cache records for an entity class are shared" do
    cache_1 = EventStore::EntityStore::Cache::Scope::Shared.build
    cache_2 = EventStore::EntityStore::Cache::Scope::Shared.build

    assert(cache_1.records.object_id == cache_2.records.object_id)
  end
end
