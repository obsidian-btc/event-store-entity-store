require_relative 'store_init'

describe "Projects Events Into the Entity from Stream that Doesn't Exist" do
  store = EventStore::EntityStore::Controls::Store::Anomaly::StreamDoesntExist::SomeStore.build

  id = Controls::ID.get

  entity = store.get id

  logger(__FILE__).info entity.inspect
  logger(__FILE__).info store.cache.inspect

  specify "Entity is nil" do
    assert(entity.nil?)
  end
end
