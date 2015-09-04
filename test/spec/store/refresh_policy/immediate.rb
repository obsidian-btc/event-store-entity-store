require_relative '../store_init'

describe "Immediate Cache Refresh Policy" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)

  cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject

  entity = EventStore::EntityStore::Controls::Entity.new
  entity.some_attribute = EventStore::EntityStore::Controls::Message.attribute

  cache.put id, entity, 0

  projection_class = EventStore::EntityStore::Controls::Projection::SomeProjection

  refresh = EventStore::EntityStore::Cache::RefreshPolicy::Immediate
  refresh.! id, cache, projection_class, stream_name, entity.class

  record = cache.get id

  specify "Projects the entity" do
    entity = record.entity
    refute(entity.nil?)
  end
end
