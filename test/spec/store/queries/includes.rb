require_relative '../store_init'

describe "Get, with Includes" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  category_name = stream_name.split('-')[0]

  specify "Entity" do
    store = EventStore::EntityStore::Controls::Store::SomeStore.build
    store.category_name = category_name

    retrieved_entity, _ = store.get id, include: :id
    refute(retrieved_entity.nil?)
  end

  specify "Single Include" do
    store = EventStore::EntityStore::Controls::Store::SomeStore.build
    store.category_name = category_name

    _, retrieved_id = store.get id, include: :id
    refute(retrieved_id.nil?)
  end

  specify "Two Includes" do
    store = EventStore::EntityStore::Controls::Store::SomeStore.build
    store.category_name = category_name

    _, version, retrieved_id = store.get id, include: [:version, :id]
    refute(version.nil?)
    refute(retrieved_id.nil?)
  end

  specify "Three Includes" do
    store = EventStore::EntityStore::Controls::Store::SomeStore.build
    store.category_name = category_name

    _, time, version, retrieved_id = store.get id, include: [:time, :version, :id]
    refute(time.nil?)
    refute(version.nil?)
    refute(retrieved_id.nil?)
  end
end
