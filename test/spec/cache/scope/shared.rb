require_relative '../cache_init'

describe "Shared Cache Scope" do
  specify "Records for caches for the same subject are shared" do
    cache_1 = EventStore::EntityStore::Cache::Scope::Shared.build :some_subject
    cache_2 = EventStore::EntityStore::Cache::Scope::Shared.build :some_subject

    assert(cache_1.records.object_id == cache_2.records.object_id)
  end

  specify "Records for caches for different subjects are not shared" do
    cache_1 = EventStore::EntityStore::Cache::Scope::Shared.build :some_subject
    cache_2 = EventStore::EntityStore::Cache::Scope::Shared.build :some_other_subject

    refute(cache_1.records.object_id == cache_2.records.object_id)
  end
end
