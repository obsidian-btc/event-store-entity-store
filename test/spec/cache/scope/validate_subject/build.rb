require_relative '../../cache_init'

describe "Validate Cache Subject when Constructing the Cache" do
  describe "Subject is valid" do
    specify "Subject is readable and writeable" do
      EventStore::EntityStore::Controls::Scope::ReadableAndWritable.build :some_subject
    end
  end

  describe "Subject is invalid" do
    specify "Subject is readable but not writeable" do
      assert_raises EventStore::EntityStore::Cache::InvalidSubjectError do
        EventStore::EntityStore::Controls::Scope::ReadableNotWritable.build :some_subject
      end
    end

    specify "Subject is not readable but writeable" do
      assert_raises EventStore::EntityStore::Cache::InvalidSubjectError do
        EventStore::EntityStore::Controls::Scope::WritableNotReadable.build :some_subject
      end
    end

    specify "Subject is not readable and not writeable" do
      assert_raises EventStore::EntityStore::Cache::InvalidSubjectError do
        EventStore::EntityStore::Controls::Scope::NotReadableNotWritable.build :some_subject
      end
    end
  end
end
