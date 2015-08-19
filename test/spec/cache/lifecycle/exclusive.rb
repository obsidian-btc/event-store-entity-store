require_relative '../cache_init'

describe "Exclusive Cache Scope" do
  specify "Unique lists of cache records" do
    cache_1 = EventStore::EntityStore::Cache::Scope::Exclusive.build
    cache_2 = EventStore::EntityStore::Cache::Scope::Exclusive.build

    refute(cache_1.records.object_id == cache_2.records.object_id)
  end
end
