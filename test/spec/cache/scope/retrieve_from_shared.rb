require_relative '../cache_init'

describe "Retrieve an Item from the Cache" do
  describe "When the Item is in the Cache" do
    entity = EventStore::EntityStore::Controls::Entity.example

    other_entity = EventStore::EntityStore::Controls::Entity.example
    other_entity.some_attribute = 'something'

    cache = EventStore::EntityStore::Cache::Scope::Shared.build entity.class

    id = UUID::Random.get
    cache.put id, entity

    other_id = UUID::Random.get
    cache.put other_id, other_entity

    cache_record = cache.get(id)

    specify "Retrieves the record" do
      assert(cache_record.entity == entity)
    end
  end

  describe "When the Item is Not in the Cache" do
    entity_class = EventStore::EntityStore::Controls::Entity.entity_class

    cache = EventStore::EntityStore::Cache::Scope::Shared.build entity_class

    some_id = UUID::Random.get

    record = cache.get(some_id)

    specify "There is no record" do
      assert(record.nil?)
    end
  end
end
