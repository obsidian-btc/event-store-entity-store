require_relative '../store_init'

describe "Missing Cache Refresh Policy" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'
  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  projection_class = EventStore::EntityStore::Controls::Projection::SomeProjection
  refresh = EventStore::EntityStore::Cache::RefreshPolicy::Missing

  describe "The entity is previously cached" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject

    entity = EventStore::EntityStore::Controls::Entity.new

    cache.put id, entity, 0

    refresh.! id, cache, projection_class, stream_name, entity.class

    record = cache.get id
    retrieved_entity = record.entity

    specify "Doesn't update the entity" do
      assert(retrieved_entity.object_id == entity.object_id)
    end
  end

  describe "The entity is not previously cached" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject

    stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'
    id = EventStore::EntityStore::Controls::StreamName.id(stream_name)

    refresh.! id, cache, projection_class, stream_name, EventStore::EntityStore::Controls::Entity.entity_class

    record = cache.get id
    entity = record.entity
    # entity is nil. implement logic to do projection, cache it, etc
    # refactor from "immediate". lot's of shared logic.

    specify "Caches the entity" do
      refute(entity.nil?)
    end
  end
end
