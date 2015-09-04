require_relative '../store_init'

describe "Select Refresh Policy Implementation" do
  specify "Immediate" do
    policy = EventStore::EntityStore::Cache::RefreshPolicy.policy_class(:immediate)
    assert(policy == EventStore::EntityStore::Cache::RefreshPolicy::Immediate)
  end

  specify "None" do
    policy = EventStore::EntityStore::Cache::RefreshPolicy.policy_class(:none)
    assert(policy == EventStore::EntityStore::Cache::RefreshPolicy::None)
  end

  specify "Age" do
    policy = EventStore::EntityStore::Cache::RefreshPolicy.policy_class(:age)
    assert(policy == EventStore::EntityStore::Cache::RefreshPolicy::Age)
  end
end

describe "Unknown" do
  specify "Error" do
    assert_raises(EventStore::EntityStore::Cache::RefreshPolicy::Error) do
      EventStore::EntityStore::Cache::RefreshPolicy.policy_class(UUID::Random.get)
    end
  end
end

describe "Default Refresh Policy" do
  specify "Immediate" do
    policy = EventStore::EntityStore::Cache::RefreshPolicy.policy_class
    assert(policy == EventStore::EntityStore::Cache::RefreshPolicy::Immediate)
  end

  specify "Can be specified with the ENTITY_CACHE_REFRESH environment variable" do
    saved_setting = EventStore::EntityStore::Cache::RefreshPolicy::Defaults::Name.env_var_value

    ENV[EventStore::EntityStore::Cache::RefreshPolicy::Defaults::Name.env_var_name] = 'none'

    policy = EventStore::EntityStore::Cache::RefreshPolicy.policy_class

    logger(__FILE__).info policy.inspect

    assert(policy == EventStore::EntityStore::Cache::RefreshPolicy::None)

    ENV[EventStore::EntityStore::Cache::RefreshPolicy::Defaults::Name.env_var_name] = saved_setting
  end
end
