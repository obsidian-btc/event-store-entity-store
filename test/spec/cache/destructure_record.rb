require_relative 'cache_init'

describe "Destructure Cache Record" do
  record = EventStore::EntityStore::Controls::Record.example

  attributes = [:id, :version, :time]

  specify "Entity only" do
    entity = record.destructure
    assert(entity == record.entity)
  end

  describe "Entity, Including Single Attribute" do
    attributes.each do |attribute|
      specify attribute.to_s.capitalize do
        entity, atr = record.destructure(attribute)

        assert(entity == record.entity)
        assert(atr == record.send(attribute))
      end
    end
  end

  describe "Entity, Including Two Attributes" do
    attributes.permutation(2).each do |attr_1, attr_2|
      specify "#{attr_1.to_s.capitalize}, #{attr_2.to_s.capitalize}" do
        entity, atr1, atr2 = record.destructure([attr_1, attr_2])

        assert(entity == record.entity)
        assert(atr1 == record.send(attr_1))
        assert(atr2 == record.send(attr_2))
      end
    end
  end

  describe "Entity, Including Three Attributes" do
    attributes.permutation(3).each do |attr_1, attr_2, attr_3|
      specify "#{attr_1.to_s.capitalize}, #{attr_2.to_s.capitalize}, #{attr_3.to_s.capitalize}" do
        entity, atr1, atr2, atr3 = record.destructure([attr_1, attr_2, attr_3])

        assert(entity == record.entity)
        assert(atr1 == record.send(attr_1))
        assert(atr2 == record.send(attr_2))
        assert(atr3 == record.send(attr_3))
      end
    end
  end
end
