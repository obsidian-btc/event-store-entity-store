require_relative '../store_init'

describe "Get Entity and ID from Store" do
  id = Controls::ID.get

  store = EventStore::EntityStore::Controls::Store::SomeStore.build

  entity = EventStore::EntityStore::Controls::Entity.example

  store.cache.put id, entity

  describe "Returns" do
    retrieved_entity, retrieved_id = store.get id, include: :id

    # specify "ID" do
    #   assert(retrieved_id == id)
    # end

    describe "Entity" do
      specify "some_attribute" do
        assert(retrieved_entity.some_attribute == EventStore::EntityStore::Controls::Message.attribute)
      end

      specify "some_time" do
        assert(retrieved_entity.some_time == EventStore::EntityStore::Controls::Message.time)
      end
    end
  end
end
