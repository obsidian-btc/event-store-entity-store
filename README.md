# EventStore Entity Store

```ruby
class SomeStore
  include EntityStore::Store

  category 'someCategory'
  entity SomeEntity
  projection SomeProjection
end

store = SomeStore.build
entity = store.get(id)
```
