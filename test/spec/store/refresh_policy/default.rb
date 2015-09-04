require_relative '../store_init'

describe "Default Refresh Policy" do
  specify "Exclusive" do
    store = EventStore::EntityStore::Controls::Store::SomeStore.build
    assert(store.refresh == EventStore::EntityStore::Cache::RefreshPolicy::Immediate)
  end
end
