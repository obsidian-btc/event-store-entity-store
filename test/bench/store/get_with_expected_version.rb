require_relative './store_init'

context "Get with Expected Version" do
  stream_name = EventStore::EntityStore::Controls::Writer.write_batch 'someEntity'

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  category_name = stream_name.split('-')[0]

  context "Right version" do
    store = EventStore::EntityStore::Controls::Store::SomeStore.build
    store.category_name = category_name

    test "Is not an error" do
      store.get id, expected_version: 1
    end
  end

  context "Wrong version" do
    store = EventStore::EntityStore::Controls::Store::SomeStore.build
    store.category_name = category_name

    test "Is an error" do
      assert proc { store.get id, expected_version: 11 } do
        raises_error? EventStore::EntityStore::Error
      end
    end
  end
end
