require_relative '../cache_init'

describe "Immediate cache refresh" do
  describe "When the Item is in the Cache" do
    entity = EventStore::EntityStore::Controls::Entity.example

    other_entity = EventStore::EntityStore::Controls::Entity.example
    other_entity.some_attribute = 'something'

    cache = EventStore::EntityStore::Cache::Scope::Exclusive.build :some_subject

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
    cache = EventStore::EntityStore::Cache::Scope::Exclusive.build :some_subject

    some_id = UUID::Random.get

    record = cache.get(some_id)

    specify "There is no record" do
      assert(record.nil?)
    end
  end
end
