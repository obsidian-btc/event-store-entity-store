# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store-entity_store'
  s.summary = 'Store of entities that are projected from EventStore streams'
  s.version = '0.1.1'
  s.authors = ['']
  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency 'set_attributes', '~> 0'
  s.add_runtime_dependency 'schema', '~> 0'
  s.add_runtime_dependency 'telemetry-logger', '~> 0'
  s.add_runtime_dependency 'dependency', '~> 0'
  s.add_runtime_dependency 'clock', '~> 0'
  s.add_runtime_dependency 'event_store-entity_projection', '~> 0'
end
