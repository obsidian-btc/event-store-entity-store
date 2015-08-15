require_relative '../store_init'

describe "Get Entity and ID from Store" do
  id = Controls::ID.get

  store = EventStore::EntityStore::Controls::Store::SomeStore.build

  entity = EventStore::EntityStore::Controls::Entity.example

  logger(__FILE__).info entity.inspect

  store.cache.put id, entity
  logger(__FILE__).info store.cache.inspect

  entity = store.get id, include: :id, cache_only: true

  logger(__FILE__).info entity.inspect

  describe "Entity Attributes" do
    specify "some_attribute" do
      assert(entity.some_attribute == EventStore::EntityStore::Controls::Message.attribute)
    end

    specify "some_time" do
      assert(entity.some_time == EventStore::EntityStore::Controls::Message.time)
    end
  end
end
