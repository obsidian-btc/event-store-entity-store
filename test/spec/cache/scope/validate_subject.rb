require_relative '../cache_init'

describe "Validate Cache Subject" do
  specify "Subject is valid" do
    EventStore::EntityStore::Controls::Scope::Valid.build :some_subject
  end

  specify "Subject is invalid" do
    assert_raises EventStore::EntityStore::Cache::InvalidSubjectError do
      EventStore::EntityStore::Controls::Scope::Invalid.build :some_subject
    end
  end
end
