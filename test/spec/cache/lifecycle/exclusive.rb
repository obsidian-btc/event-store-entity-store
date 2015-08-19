require_relative '../cache_init'

describe "Exclusive Cache Scope" do
  specify "List of cache records is exclusive to the cache instance" do
    cache_1 = EventStore::EntityStore::Cache::Scope::Exclusive.build
    cache_2 = EventStore::EntityStore::Cache::Scope::Exclusive.build

    refute(cache_1.records.object_id == cache_2.records.object_id)
  end
end
