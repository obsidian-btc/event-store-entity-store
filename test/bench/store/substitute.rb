require_relative './store_init'

context "Store Substitute" do
  store = EventStore::EntityStore::Substitute.build

  id = ::Controls::ID.get

  entity = EventStore::EntityStore::Controls::Entity.new

  version = 1
  cached_time = Time.now

  context "Retrieval of an added entity" do
    initial_cache_record = store.add id, entity, version, cached_time
    retrieved_entity, retrieved_version, retrieved_time = store.get id, include: [:version, :time]

    test "Entity" do
      assert(retrieved_entity.object_id == entity.object_id)
    end

    test "Version" do
      assert(retrieved_version == initial_cache_record.version)
    end

    test "Time" do
      assert(retrieved_time == initial_cache_record.time)
    end
  end

  context "Retrieval of an added hash of IDs and entities" do
    entities = { id => entity}

    records = store.merge entities, version, cached_time
    initial_cache_record = records.first

    retrieved_entity, retrieved_version, retrieved_time = store.get id, include: [:version, :time]

    test "Entity" do
      assert(retrieved_entity.object_id == entity.object_id)
    end

    test "Version" do
      assert(retrieved_version == initial_cache_record.version)
    end

    test "Time" do
      assert(retrieved_time == initial_cache_record.time)
    end
  end

  context "Retrieval of an added array of entities" do
    entities = [ entity ]

    records = store.merge entities, version, cached_time
    initial_cache_record = records.first

    retrieved_entity, retrieved_version, retrieved_time = store.get id, include: [:version, :time]

    test "Entity" do
      assert(retrieved_entity.object_id == entity.object_id)
    end

    test "Version" do
      assert(retrieved_version == initial_cache_record.version)
    end

    test "Time" do
      assert(retrieved_time == initial_cache_record.time)
    end
  end
end
