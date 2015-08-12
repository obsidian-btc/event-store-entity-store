require_relative 'spec_init'

describe "Store" do
  specify "Avails the \"category\" macro" do
    has_category_macro = EventStore::EntityStore::Controls::Store::SomeStore.respond_to? :category
    assert(has_category_macro)
  end

  specify "Specifies the category name that it services" do
    store = EventStore::EntityStore::Controls::Store.example
    assert(store.category_name == EventStore::EntityStore::Controls::Store.category)
  end

  specify "Allows the category name to be overridden" do
    store = EventStore::EntityStore::Controls::Store.example
    store.category_name = 'other_category'
    assert(store.category_name == 'other_category')
  end

  specify "Avails the \"entity\" macro" do
    has_entity_macro = EventStore::EntityStore::Controls::Store::SomeStore.respond_to? :entity
    assert(has_entity_macro)
  end

  specify "Specifies the entity class that it services" do
    store = EventStore::EntityStore::Controls::Store.example
    assert(store.entity_class == EventStore::EntityStore::Controls::Entity.entity_class)
  end

  specify "Avails the \"projection\" macro" do
    has_projection_macro = EventStore::EntityStore::Controls::Store::SomeStore.respond_to? :projection
    assert(has_projection_macro)
  end

  specify "Specifies the projection class that it services" do
    store = EventStore::EntityStore::Controls::Store.example
    assert(store.projection_class == EventStore::EntityStore::Controls::Projection::SomeProjection)
  end
end
