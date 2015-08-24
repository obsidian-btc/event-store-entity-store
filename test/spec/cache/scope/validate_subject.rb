require_relative '../cache_init'

describe "Validate Cache Subject" do
  specify "Valid" do
    entity = EventStore::EntityProjection::Controls::Entity.example

    unique_scope_id = UUID::Random.get

    EventStore::EntityStore::Cache::Factory.scopes[unique_scope_id] =
      EventStore::EntityStore::Controls::Scope::Valid

    EventStore::EntityStore::Cache::Factory.build_cache :some_subject, scope: unique_scope_id
  end

  specify "Valid" do
    entity = EventStore::EntityProjection::Controls::Entity.example

    unique_scope_id = UUID::Random.get

    EventStore::EntityStore::Cache::Factory.scopes[unique_scope_id] =
      EventStore::EntityStore::Controls::Scope::Invalid

    assert_raises EventStore::EntityStore::Cache::InvalidSubjectError do
      EventStore::EntityStore::Cache::Factory.build_cache :some_subject, scope: unique_scope_id
    end
  end
end
