require_relative '../cache_init'

describe "Select Cache Scope Implementation" do
  specify "Default is Exclusive" do
    cache = EventStore::EntityStore::Cache.build
    assert(cache.is_a? EventStore::EntityStore::Cache::Scope::Exclusive)
  end

  specify "Exclusive" do
    cache = EventStore::EntityStore::Cache.build scope: :exclusive
    assert(cache.is_a? EventStore::EntityStore::Cache::Scope::Exclusive)
  end

  specify "Shared" do
    cache = EventStore::EntityStore::Cache.build scope: :shared
    assert(cache.is_a? EventStore::EntityStore::Cache::Scope::Shared)
  end

  specify "Error if unknown" do
    assert_raises(EventStore::EntityStore::Cache::Scope::Error) do
      EventStore::EntityStore::Cache.build scope: UUID.random
    end
  end
end
