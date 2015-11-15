require_relative 'cache_init'

describe "Destructure Cache Record When No Stream is Found" do
  record_class = EventStore::EntityStore::Cache::Record::NoStream

  attributes = [:id, :version, :time]

  specify "Entity only" do
    entity = record_class.destructure
    assert(entity == nil)
  end

  specify "Version is :no_stream" do
    _, version = record_class.destructure(:version)
    assert(version == :no_stream)
  end

  describe "Entity, Including Single Attribute" do
    attributes.each do |attribute|
      specify attribute.to_s.capitalize do
        entity, value = record_class.destructure(attribute)

        assert_nil_attribute(:entity, entity)
        assert_nil_attribute(attribute, value)
      end
    end
  end

  describe "Entity, Including Two Attributes" do
    attributes.permutation(2).each do |attribute_1, attribute_2|
      specify "#{attribute_1.to_s.capitalize}, #{attribute_2.to_s.capitalize}" do
        entity, value_1, value_2 = record_class.destructure([attribute_1, attribute_2])

        assert_nil_attribute(:entity, entity)
        assert_nil_attribute(attribute_1, value_1)
        assert_nil_attribute(attribute_2, value_2)
      end
    end
  end

  describe "Entity, Including Three Attributes" do
    attributes.permutation(3).each do |attribute_1, attribute_2, attribute_3|
      specify "#{attribute_1.to_s.capitalize}, #{attribute_2.to_s.capitalize}, #{attribute_3.to_s.capitalize}" do
        entity, value_1, value_2, value_3 = record_class.destructure([attribute_1, attribute_2, attribute_3])

        assert_nil_attribute(:entity, entity)
        assert_nil_attribute(attribute_1, value_1)
        assert_nil_attribute(attribute_2, value_2)
        assert_nil_attribute(attribute_3, value_3)
      end
    end
  end

  def assert_nil_attribute(attribute, value)
    if attribute == :version
      assert(value == EventStore::EntityStore::Cache::Record::NoStream.version)
    else
      assert(value.nil?)
    end
  end
end
