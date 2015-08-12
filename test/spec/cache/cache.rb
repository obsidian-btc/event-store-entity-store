require_relative 'cache_init'

describe "Retrieve an Item from the Cache" do
  describe "When the Item is in the Cache" do
    entity = EventStore::EntityStore::Controls::Entity.example

    other_entity = EventStore::EntityStore::Controls::Entity.example
    other_entity.some_attribute = 'something'

    cache = EventStore::EntityStore::Cache.build

    id = UUID::Random.get
    cache.put id, entity

    other_id = UUID::Random.get
    cache.put other_id, other_entity

    retrieved_entity = cache.get(id)

    specify "Retrieves the entity" do
      assert(retrieved_entity == entity)
    end
  end

  describe "When the Item is Not in the Cache" do
    cache = EventStore::EntityStore::Cache.build

    some_id = UUID::Random.get

    entity = cache.get(some_id)

    specify "Entity is represented as nil" do
      assert(entity.nil?)
    end
  end
end
