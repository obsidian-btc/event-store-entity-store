require_relative '../store_init'

describe "Immediate Cache Refresh Policy" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'
  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  projection_class = EventStore::EntityStore::Controls::Projection::SomeProjection
  refresh = EventStore::EntityStore::Cache::RefreshPolicy::None

  describe "The entity is previously cached" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject

    entity = EventStore::EntityStore::Controls::Entity.new
    cache.put id, entity, 0

    refresh.! id, cache, projection_class, stream_name, entity.class

    describe "Doesn't update the entity" do
      record = cache.get id
      entity = record.entity

      specify "some_attribute is not projected" do
        assert(entity.some_attribute.nil?)
      end

      specify "some_time is not projected" do
        assert(entity.some_time.nil?)
      end
    end
  end

  describe "The entity is not previously cached" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject

    refresh.! id, cache, projection_class, stream_name, EventStore::EntityStore::Controls::Entity

    record = cache.get id

    specify "Doesn't cache the entity" do
      assert(record.nil?)
    end
  end
end
