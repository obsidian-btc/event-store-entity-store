require_relative '../cache_init'

context "Retrieve an Item from the Cache" do
  context "When the Item is in the Cache" do
    entity = EventStore::EntityStore::Controls::Entity.example

    other_entity = EventStore::EntityStore::Controls::Entity.example
    other_entity.some_attribute = 'something'

    cache = EventStore::EntityStore::Cache::Scope::Exclusive.build :some_subject

    id = Identifier::UUID::Random.get
    cache.put id, entity

    other_id = Identifier::UUID::Random.get
    cache.put other_id, other_entity

    cache_record = cache.get(id)

    test "Retrieves the record" do
      assert(cache_record.entity == entity)
    end
  end

  context "When the Item is Not in the Cache" do
    cache = EventStore::EntityStore::Cache::Scope::Exclusive.build :some_subject

    some_id = Identifier::UUID::Random.get

    record = cache.get(some_id)

    test "There is no record" do
      assert(record.nil?)
    end
  end
end
