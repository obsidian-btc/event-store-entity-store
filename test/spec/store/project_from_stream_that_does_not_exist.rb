require_relative 'store_init'

describe "Projects Events Into the Entity from Stream that Doesn't Exist" do
  store = EventStore::EntityStore::Controls::Store::Anomaly::StreamDoesntExist::SomeStore.build

  id = Controls::ID.get

  entity = store.get id

  specify "Entity is nil" do
    assert(entity.nil?)
  end

  specify "Entity is not cached" do
    cache_record = store.cache.get(id)
    assert(cache_record.nil?)
  end
end
