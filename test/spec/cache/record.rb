require_relative 'cache_init'

describe "Cache Record" do
  cache = EventStore::EntityStore::Cache.build

  id = UUID::Random.get
  version = 11
  time = Clock::UTC.iso8601

  entity = EventStore::EntityStore::Controls::Entity.example

  cache.put id, entity, version, time

  record = cache.get_record(id)

  specify "Entity" do
    assert(record.entity == entity)
  end

  specify "Version" do
    assert(record.version == version)
  end

  specify "Time" do
    assert(record.time == time)
  end

  specify "Age" do
    logger(__FILE__).data "(#{record.age.class}) #{record.age}"
  end
end
