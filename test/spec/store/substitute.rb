require_relative './store_init'

describe "Store Substitute" do
  store = EventStore::EntityStore::Substitute.build

  id = ::Controls::ID.get

  entity = EventStore::EntityStore::Controls::Entity.new

  version = 1
  cached_time = Time.now

  describe "Retrieval of an added entity" do
    initial_cache_record = store.add id, entity, version, cached_time
    retrieved_entity, retrieved_version, retrieved_time = store.get id, include: [:version, :time]

    specify "Entity" do
      assert(retrieved_entity.object_id == entity.object_id)
    end

    specify "Version" do
      assert(retrieved_version == initial_cache_record.version)
    end

    specify "Time" do
      assert(retrieved_time == initial_cache_record.time)
    end
  end

  describe "Retrieval of an added list of IDs and entities" do
    entities = { id => entity}

    store.merge entities

    retrieved_entity, retrieved_version, retrieved_time = store.get id, include: [:version, :time]

    specify "Entity" do
      assert(retrieved_entity.object_id == entity.object_id)
    end

    specify "Version" do
      assert(retrieved_version == 0)
    end

    # specify "Time" do
    #   assert(retrieved_time == initial_cache_record.time)
    # end
  end
end
