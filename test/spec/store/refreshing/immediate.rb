require_relative '../store_init'

require_relative '../store_init'

describe "Get Entity Using the Immediate Refresh Policy" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  store = EventStore::EntityStore::Controls::Store::SomeStore.build refresh: :immediate
  category_name = stream_name.split('-')[0]
  store.category_name = category_name

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)

  cache = store.cache

  entity = EventStore::EntityStore::Controls::Entity.new
  entity.some_attribute = EventStore::EntityStore::Controls::Message.attribute

  initial_cache_record = cache.put id, entity, 0

  retrieved_entity, version, time = store.get id, include: [:version, :time]

  describe "Cache is refreshed" do
    specify "Entity" do
      refute(entity.nil?)
    end

    specify "Version is updated" do
      refute(version == initial_cache_record.version)
    end

    specify "Time is updated" do
      refute(time == initial_cache_record.time)
    end
  end
end
