# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store-entity_store'
  s.version = '0.2.0.1'
  s.summary = 'Store of entities that are projected from EventStore streams'
  s.description = ' '

  s.authors = ['Obsidian Software, Inc']
  s.email = 'opensource@obsidianexchange.com'
  s.homepage = 'https://github.com/obsidian-btc/event-store-entity-store'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.3'

  s.add_runtime_dependency 'event_store-entity_projection'

  s.add_development_dependency 'test_bench'
end
