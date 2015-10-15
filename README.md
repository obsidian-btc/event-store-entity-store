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

## License

The `event_store-entity_store` library is released under the [MIT License](https://github.com/obsidian-btc/event-store-entity-store/blob/master/MIT-License.txt).
