require_relative 'cache_init'

describe "Destructure Cache Record" do
  record = EventStore::EntityStore::Controls::Record.example

  specify "Entity only" do
    entity = record.destructure
    assert(entity == record.entity)
  end

  # describe "Entity, Including" do
  #   specify "ID" do
  #     entity, id = record.destructure([:id])

  #     assert(entity == record.entity)
  #     assert(id == record.entity)
  #   end
  # end

  describe "Entity, Including" do
    specify "Version" do
      entity, version = record.destructure([:version])

      assert(entity == record.entity)
      assert(version == record.version)
    end

    specify "Time" do
      entity, time = record.destructure([:time])

      assert(entity == record.entity)
      assert(time == record.time)
    end
  end
end
