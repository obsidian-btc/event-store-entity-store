require_relative '../../cache_init'

context "Validate Subject when Getting from the Cache" do
  id = Identifier::UUID::Random.get

  context "Subject is valid" do
    test "Subject is readable and writeable" do
      cache = EventStore::EntityStore::Controls::Scope::ReadableAndWritable.new :some_subject
      cache.get id
    end

    test "Subject is readable" do
      cache = EventStore::EntityStore::Controls::Scope::ReadableNotWritable.new :some_subject
      cache.get id
    end
  end

  context "Subject is invalid" do
    test "Subject is not readable but writeable" do
      cache = EventStore::EntityStore::Controls::Scope::WritableNotReadable.new :some_subject
      begin
        cache.get id
      rescue EventStore::EntityStore::Cache::InvalidSubjectError => error
      end

      assert error
    end

    test "Subject is not readable and not writeable" do
      cache = EventStore::EntityStore::Controls::Scope::NotReadableNotWritable.new :some_subject
      begin
        cache.get id
      rescue EventStore::EntityStore::Cache::InvalidSubjectError => error
      end

      assert error
    end
  end
end
