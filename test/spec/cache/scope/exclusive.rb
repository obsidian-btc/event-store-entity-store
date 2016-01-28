require_relative '../cache_init'

context "Exclusive Cache Scope" do
  test "List of cache records is exclusive to the cache instance" do
    cache_1 = EventStore::EntityStore::Cache::Scope::Exclusive.build :some_subject
    cache_2 = EventStore::EntityStore::Cache::Scope::Exclusive.build :some_subject

    assert(cache_1.records.object_id != cache_2.records.object_id)
  end
end
