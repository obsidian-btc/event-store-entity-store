require_relative '../../cache_init'

context "Validate Cache Subject when Constructing the Cache" do
  context "Subject is valid" do
    test "Subject is readable and writeable" do
      EventStore::EntityStore::Controls::Scope::ReadableAndWritable.build :some_subject
    end
  end

  context "Subject is invalid" do
    test "Subject is readable but not writeable" do
      begin
        EventStore::EntityStore::Controls::Scope::ReadableNotWritable.build :some_subject
      rescue EventStore::EntityStore::Cache::InvalidSubjectError => error
      end

      assert error
    end

    test "Subject is not readable but writeable" do
      begin
        EventStore::EntityStore::Controls::Scope::WritableNotReadable.build :some_subject
      rescue EventStore::EntityStore::Cache::InvalidSubjectError => error
      end

      assert error
    end

    test "Subject is not readable and not writeable" do
      begin
        EventStore::EntityStore::Controls::Scope::NotReadableNotWritable.build :some_subject
      rescue EventStore::EntityStore::Cache::InvalidSubjectError => error
      end

      assert error
    end
  end
end
