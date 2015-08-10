require_relative 'spec_init'

=begin
store = ..

entity, version = store.get(id, include: :version)
entity, version = store.get(id, include: [:version, :time, :age])

Struct.new(:entity, :version, :retrieved_time)
=end

# - - -

# EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.! entity, stream_name, starting_position: entity_version

# class SomeStore
#   include Store

#   category :some_entity
# end

# store = SomeStore.build

# entity = store.get(id) # what is the id? id is uuid

# - - -

require_relative 'spec_init'

describe "Get Entity from Store" do
  stream_name = EventStore::EntityStore::Controls::Writer.write 'someEntity'

  entity = EventStore::EntityStore::Controls::Entity.example

  # EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.! entity, stream_name, starting_position: 0, slice_size: 1

  # describe "Entity Attributes" do
  #   specify "some_attribute" do
  #     assert(entity.some_attribute == EventStore::EntityProjection::Controls::Message.attribute)
  #   end

  #   specify "some_time" do
  #     assert(entity.some_time == EventStore::EntityProjection::Controls::Message.time)
  #   end
  # end
end
