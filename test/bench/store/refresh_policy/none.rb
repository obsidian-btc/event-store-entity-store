require_relative '../store_init'

context "None Cache Refresh Policy" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'
  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  projection_class = EventStore::EntityStore::Controls::Projection::SomeProjection
  refresh = EventStore::EntityStore::Cache::RefreshPolicy::None

  context "The entity is not previously cached" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject

    refresh.(id, cache, projection_class, stream_name, EventStore::EntityStore::Controls::Entity)

    record = cache.get id

    test "Doesn't cache the entity" do
      assert(record.nil?)
    end
  end

  context "The entity is previously cached" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject

    entity = EventStore::EntityStore::Controls::Entity.new
    cache.put id, entity, 0

    refresh.(id, cache, projection_class, stream_name, entity.class)

    context "Doesn't update the entity" do
      record = cache.get id
      entity = record.entity

      test "some_attribute is not projected" do
        assert(entity.some_attribute.nil?)
      end

      test "some_time is not projected" do
        assert(entity.some_time.nil?)
      end
    end
  end
end
