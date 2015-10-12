require_relative '../../cache_init'

describe "Validate Subject when Getting from the Cache" do
  id = Identifier::UUID::Random.get

  describe "Subject is valid" do
    specify "Subject is readable and writeable" do
      cache = EventStore::EntityStore::Controls::Scope::ReadableAndWritable.new :some_subject
      cache.get id
    end

    specify "Subject is readable" do
      cache = EventStore::EntityStore::Controls::Scope::ReadableNotWritable.new :some_subject
      cache.get id
    end
  end

  describe "Subject is invalid" do
    specify "Subject is not readable but writeable" do
      cache = EventStore::EntityStore::Controls::Scope::WritableNotReadable.new :some_subject
      assert_raises EventStore::EntityStore::Cache::InvalidSubjectError do
        cache.get id
      end
    end

    specify "Subject is not readable and not writeable" do
      cache = EventStore::EntityStore::Controls::Scope::NotReadableNotWritable.new :some_subject
      assert_raises EventStore::EntityStore::Cache::InvalidSubjectError do
        cache.get id
      end
    end
  end
end
