require_relative '../store_init'

describe "Immediate Cache Refresh Policy" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'
  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  projection_class = EventStore::EntityStore::Controls::Projection::SomeProjection
  refresh = EventStore::EntityStore::Cache::RefreshPolicy::Immediate

  describe "The entity is previously cached" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject

    entity = EventStore::EntityStore::Controls::Entity.new
    cache.put id, entity, 0

    refresh.(id, cache, projection_class, stream_name, entity.class)

    record = cache.get id
    entity = record.entity

    describe "Updates the cached entity" do
      specify "some_attribute is not projected due as the cached version is 0" do
        assert(entity.some_attribute.nil?)
      end

      specify "some_time is projected" do
        refute(entity.some_time.nil?)
      end
    end
  end

  describe "The entity is not previously cached" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject

    refresh.(id, cache, projection_class, stream_name, EventStore::EntityStore::Controls::Entity)

    record = cache.get id
    entity = record.entity

    specify "Caches the entity" do
      refute(entity.nil?)
    end
  end
end
