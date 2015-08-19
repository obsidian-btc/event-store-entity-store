require_relative '../cache_init'

describe "Individual Cache Instances" do
  specify "Have unique lists of cache records" do
    cache_1 = EventStore::EntityStore::Cache::Lifecycle::Instance.build
    cache_2 = EventStore::EntityStore::Cache::Lifecycle::Instance.build

    refute(cache_1.records.object_id == cache_2.records.object_id)
  end
end
