require_relative '../store_init'

context "Immediate Cache Refresh Policy" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'
  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  projection_class = EventStore::EntityStore::Controls::Projection::SomeProjection
  refresh = EventStore::EntityStore::Cache::RefreshPolicy::Immediate

  context "The entity is previously cached" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject

    entity = EventStore::EntityStore::Controls::Entity.new
    cache.put id, entity, 0

    refresh.(id, cache, projection_class, stream_name, entity.class)

    record = cache.get id
    entity = record.entity

    context "Updates the cached entity" do
      test "some_attribute is not projected due as the cached version is 0" do
        assert(entity.some_attribute.nil?)
      end

      test "some_time is projected" do
        assert(!entity.some_time.nil?)
      end
    end
  end

  context "The entity is not previously cached" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject

    refresh.(id, cache, projection_class, stream_name, EventStore::EntityStore::Controls::Entity)

    record = cache.get id
    entity = record.entity

    test "Caches the entity" do
      assert(!entity.nil?)
    end
  end
end
