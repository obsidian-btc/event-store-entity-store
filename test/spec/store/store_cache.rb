require_relative 'store_init'

describe "Store's Cache Scope" do
  specify "Exclusive" do
    store = EventStore::EntityStore::Controls::Store.example cache_scope: :exclusive
    assert(store.cache.is_a? EventStore::EntityStore::Cache::Scope::Exclusive)
  end

  specify "Shared" do
    store = EventStore::EntityStore::Controls::Store.example cache_scope: :shared
    assert(store.cache.is_a? EventStore::EntityStore::Cache::Scope::Shared)
  end

  specify "Error if unknown" do
    assert_raises(EventStore::EntityStore::Cache::Scope::Error) do
      EventStore::EntityStore::Controls::Store.example cache_scope: UUID.random
    end
  end
end

describe "Default Cache Scope Implementation" do
  specify "Exclusive" do
    store = EventStore::EntityStore::Controls::Store.example
    assert(store.cache.is_a? EventStore::EntityStore::Cache::Scope::Exclusive)
  end
end
