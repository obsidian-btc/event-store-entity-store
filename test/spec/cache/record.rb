require_relative 'cache_init'

context "Cache Record" do
  cache = EventStore::EntityStore::Cache::Scope::Exclusive.build :some_subject

  id = Identifier::UUID::Random.get
  version = 11
  time = Clock::UTC.iso8601

  entity = EventStore::EntityStore::Controls::Entity.example

  cache.put id, entity, version, time

  record = cache.get(id)

  test "Entity" do
    assert(record.entity == entity)
  end

  test "ID" do
    assert(record.id == id)
  end

  test "Version" do
    assert(record.version == version)
  end

  test "Time" do
    assert(record.time == time)
  end

  test "Age" do
    __logger.data "(#{record.age.class}) #{record.age}"
  end
end
