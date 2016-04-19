require 'virtual'; Virtual.activate

require 'event_store/entity_projection'

require 'event_store/entity_store/cache/refresh_policy'
require 'event_store/entity_store/cache/refresh_policy/immediate'
require 'event_store/entity_store/cache/refresh_policy/none'
require 'event_store/entity_store/cache/refresh_policy/missing'
require 'event_store/entity_store/cache/scope'
require 'event_store/entity_store/cache/scope/exclusive'
require 'event_store/entity_store/cache/scope/shared'
require 'event_store/entity_store/cache/record'
require 'event_store/entity_store/cache/factory'
require 'event_store/entity_store/cache'
require 'event_store/entity_store/entity_store'
