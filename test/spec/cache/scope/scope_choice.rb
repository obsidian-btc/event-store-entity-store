require_relative '../cache_init'

describe "Select Cache Scope Implementation" do
  specify "Exclusive" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject, scope: :exclusive
    assert(cache.is_a? EventStore::EntityStore::Cache::Scope::Exclusive)
  end

  specify "Shared" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject, scope: :shared
    assert(cache.is_a? EventStore::EntityStore::Cache::Scope::Shared)
  end

  specify "Error if unknown" do
    assert_raises(EventStore::EntityStore::Cache::Scope::Error) do
      EventStore::EntityStore::Cache::Factory.build_cache :some_subject, scope: SecureRandom.random_bytes
    end
  end
end

describe "Default Cache Scope Implementation" do
  specify "Exclusive" do
    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject
    assert(cache.is_a? EventStore::EntityStore::Cache::Scope::Exclusive)
  end

  specify "Can be specified with the ENTITY_CACHE environment variable" do
    saved_cache_setting = EventStore::EntityStore::Cache::Scope::Defaults::Name.env_var_value

    ENV[EventStore::EntityStore::Cache::Scope::Defaults::Name.env_var_name] = 'shared'

    cache = EventStore::EntityStore::Cache::Factory.build_cache :some_subject
    assert(cache.is_a? EventStore::EntityStore::Cache::Scope::Shared)

    ENV[EventStore::EntityStore::Cache::Scope::Defaults::Name.env_var_name] = saved_cache_setting
  end
end
