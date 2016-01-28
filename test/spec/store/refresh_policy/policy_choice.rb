require_relative '../store_init'

context "Select Refresh Policy Implementation" do
  test "Immediate" do
    policy = EventStore::EntityStore::Cache::RefreshPolicy.policy_class(:immediate)
    assert(policy == EventStore::EntityStore::Cache::RefreshPolicy::Immediate)
  end

  test "None" do
    policy = EventStore::EntityStore::Cache::RefreshPolicy.policy_class(:none)
    assert(policy == EventStore::EntityStore::Cache::RefreshPolicy::None)
  end

  test "Missing" do
    EventStore::EntityStore::Cache::RefreshPolicy.policies[:missing] = EventStore::EntityStore::Cache::RefreshPolicy::Missing

    policy = EventStore::EntityStore::Cache::RefreshPolicy.policy_class(:missing)
    assert(policy == EventStore::EntityStore::Cache::RefreshPolicy::Missing)
  end
end

context "Unknown" do
  test "Error" do
    begin
      EventStore::EntityStore::Cache::RefreshPolicy.policy_class(SecureRandom.random_bytes)
    rescue EventStore::EntityStore::Cache::RefreshPolicy::Error => error
    end

    assert error
  end
end

context "Default Refresh Policy" do
  test "Immediate" do
    policy = EventStore::EntityStore::Cache::RefreshPolicy.policy_class
    assert(policy == EventStore::EntityStore::Cache::RefreshPolicy::Immediate)
  end

  test "Can be specified with the ENTITY_CACHE_REFRESH environment variable" do
    saved_setting = EventStore::EntityStore::Cache::RefreshPolicy::Defaults::Name.env_var_value

    ENV[EventStore::EntityStore::Cache::RefreshPolicy::Defaults::Name.env_var_name] = 'none'

    policy = EventStore::EntityStore::Cache::RefreshPolicy.policy_class

    __logger.info policy.inspect

    assert(policy == EventStore::EntityStore::Cache::RefreshPolicy::None)

    ENV[EventStore::EntityStore::Cache::RefreshPolicy::Defaults::Name.env_var_name] = saved_setting
  end
end
