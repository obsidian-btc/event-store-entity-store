require_relative 'store_init'

context "Store's Cache Scope" do
  test "Exclusive" do
    store = EventStore::EntityStore::Controls::Store.example cache_scope: :exclusive
    assert(store.cache.is_a? EventStore::EntityStore::Cache::Scope::Exclusive)
  end

  test "Shared" do
    store = EventStore::EntityStore::Controls::Store.example cache_scope: :shared
    assert(store.cache.is_a? EventStore::EntityStore::Cache::Scope::Shared)
  end

  test "Error if unknown" do
    assert proc { EventStore::EntityStore::Controls::Store.example cache_scope: SecureRandom.random_bytes } do
      raises_error? EventStore::EntityStore::Cache::Scope::Error
    end
  end
end

context "Default Cache Scope Implementation" do
  test "Shared" do
    store = EventStore::EntityStore::Controls::Store.example
    assert(store.cache.is_a? EventStore::EntityStore::Cache::Scope::Shared)
  end
end
