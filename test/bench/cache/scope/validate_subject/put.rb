require_relative '../../cache_init'

context "Validate Subject when Putting test Into the Cache" do
  id = Identifier::UUID::Random.get

  context "Subject is valid" do
    test "Subject is readable and writeable" do
      cache = EventStore::EntityStore::Controls::Scope::ReadableAndWritable.new :some_subject
      cache.put id, 'some value'
    end

    test "Subject is writeable" do
      cache = EventStore::EntityStore::Controls::Scope::WritableNotReadable.new :some_subject
      cache.put id, 'some value'
    end
  end

  context "Subject is invalid" do
    test "Subject is readable and not writeable" do
      cache = EventStore::EntityStore::Controls::Scope::ReadableNotWritable.new :some_subject

      assert proc { cache.put id, 'some value' } do
        raises_error? EventStore::EntityStore::Cache::InvalidSubjectError
      end
    end

    test "Subject is not readable and not writeable" do
      cache = EventStore::EntityStore::Controls::Scope::NotReadableNotWritable.new :some_subject

      assert proc { cache.put id, 'some value' } do
        raises_error? EventStore::EntityStore::Cache::InvalidSubjectError
      end
    end
  end
end
