require_relative 'store_init'

context "Store" do
  test "Avails the \"category\" macro" do
    has_category_macro = EventStore::EntityStore::Controls::Store::SomeStore.respond_to? :category
    assert(has_category_macro)
  end

  test "Specifies the category name that it services" do
    store = EventStore::EntityStore::Controls::Store.example
    assert(store.category_name == EventStore::EntityStore::Controls::Store.category)
  end

  test "Allows the category name to be overridden" do
    store = EventStore::EntityStore::Controls::Store.example
    store.category_name = 'other_category'
    assert(store.category_name == 'other_category')
  end

  test "Avails the \"entity\" macro" do
    has_entity_macro = EventStore::EntityStore::Controls::Store::SomeStore.respond_to? :entity
    assert(has_entity_macro)
  end

  test "Specifies the entity class that it services" do
    store = EventStore::EntityStore::Controls::Store.example
    assert(store.entity_class == EventStore::EntityStore::Controls::Entity.entity_class)
  end

  test "Avails the \"projection\" macro" do
    has_projection_macro = EventStore::EntityStore::Controls::Store::SomeStore.respond_to? :projection
    assert(has_projection_macro)
  end

  test "Specifies the projection class that it services" do
    store = EventStore::EntityStore::Controls::Store.example
    assert(store.projection_class == EventStore::EntityStore::Controls::Projection::SomeProjection)
  end
end
