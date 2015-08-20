# To Do

0. Noop implementation
  - always reads projection

1. Cache implementations
  - Instance
  - Singleton
  - Null (substitute)

2. Refresh Strategy
  - refresh all the time
  - null (never refresh)
  - refresh based on age

3. Vertx shared cache


data access in store
- it's an 'update strategy'
- maybe 'refresh'
- so, on get, tell store to refresh
- tell it to refresh on get when age of cached item is greater than some number of milliseconds

refresh now
- store.get id, include: version, refresh_age: 0

refresh if older than 250 milliseconds
- store.get id, include: version, refresh_age: 0

- otherwise, refreshes never (ie, counting on other process to do it)

- unless refresh_always

- store.get_fresh

- Store.build refresh: Refresh.new
- refresh.projection = store.projection
- otherwise, refresh is noop
