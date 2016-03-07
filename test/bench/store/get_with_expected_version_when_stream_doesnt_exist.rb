require_relative './store_init'

context "Get with Expected Version When Stream Doesn't Exist" do
  stream_name = "stream#{SecureRandom.hex}-#{SecureRandom.uuid}"

  id = EventStore::EntityStore::Controls::StreamName.id(stream_name)
  category_name = stream_name.split('-')[0]

  store = EventStore::EntityStore::Controls::Store::SomeStore.build
  store.category_name = category_name

  test "Is an error" do
    assert proc { store.get id, expected_version: 11 } do
      raises_error? EventStore::EntityStore::Error
    end
  end
end
