require_relative '../../cache_init'

describe "Validate Subject when Putting it Into the Cache" do
  id = UUID::Random.get

  describe "Subject is valid" do
    specify "Subject is readable and writeable" do
      cache = EventStore::EntityStore::Controls::Scope::ReadableAndWritable.new :some_subject
      cache.put id, 'some value'
    end

    specify "Subject is writeable" do
      cache = EventStore::EntityStore::Controls::Scope::WritableNotReadable.new :some_subject
      cache.put id, 'some value'
    end
  end

  describe "Subject is invalid" do
    specify "Subject is readable and not writeable" do
      cache = EventStore::EntityStore::Controls::Scope::ReadableNotWritable.new :some_subject
      assert_raises EventStore::EntityStore::Cache::InvalidSubjectError do
        cache.put id, 'some value'
      end
    end

    specify "Subject is not readable and not writeable" do
      cache = EventStore::EntityStore::Controls::Scope::NotReadableNotWritable.new :some_subject
      assert_raises EventStore::EntityStore::Cache::InvalidSubjectError do
        cache.put id, 'some value'
      end
    end
  end
end
