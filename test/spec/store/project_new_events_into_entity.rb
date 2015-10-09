require_relative 'store_init'

describe "Projects New Events Into the Entity" do
  stream_name = EventStore::EntityStore::Controls::StreamName.get 'someEntity'
  store = EventStore::EntityStore::Controls::Store::SomeStore.build
  category_name = stream_name.split('-')[0]
  store.category_name = category_name

  EventStore::EntityStore::Controls::Writer.write_first stream_name

  entity = EventStore::EntityStore::Controls::Entity.new
  EventStore::EntityStore::Controls::Projection::SomeProjection.(entity, stream_name)

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)

  store.cache.put id, entity

  describe "Entity Attributes" do
    EventStore::EntityStore::Controls::Writer.write_second stream_name

    retrieved_entity = store.get id

    specify "some_attribute" do
      assert(entity.some_attribute == EventStore::EntityStore::Controls::Message.attribute)
    end

    specify "some_time" do
      assert(entity.some_time == EventStore::EntityStore::Controls::Message.time)
    end
  end
end
