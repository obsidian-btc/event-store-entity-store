require_relative '../cache_init'

context "Select Cache Scope Implementation" do
  test "Exclusive" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject, scope: :exclusive
    assert(cache.is_a? EventStore::EntityStore::Cache::Scope::Exclusive)
  end

  test "Shared" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject, scope: :shared
    assert(cache.is_a? EventStore::EntityStore::Cache::Scope::Shared)
  end

  test "Error if unknown" do
    begin
      EventStore::EntityStore::Cache::Factory.build_cache :some_subject, scope: SecureRandom.random_bytes
    rescue EventStore::EntityStore::Cache::Scope::Error => error
    end

    assert error
  end
end

context "Default Cache Scope Implementation" do
  test "Shared" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject
    assert(cache.is_a? EventStore::EntityStore::Cache::Scope::Shared)
  end

  test "Can be specified with the ENTITY_CACHE environment variable" do
    saved_cache_setting = EventStore::EntityStore::Cache::Scope::Defaults::Name.env_var_value

    ENV[EventStore::EntityStore::Cache::Scope::Defaults::Name.env_var_name] = 'exclusive'

    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject
    assert(cache.is_a? EventStore::EntityStore::Cache::Scope::Exclusive)

    ENV[EventStore::EntityStore::Cache::Scope::Defaults::Name.env_var_name] = saved_cache_setting
  end
end
