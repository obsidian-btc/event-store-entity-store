# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store_entity_store'
  s.summary = 'Store of entities that are projected from EventStore streams'
  s.version = '0.0.0'
  s.authors = ['']
  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency 'inclusion', '1.0.0'
end
