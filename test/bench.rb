require_relative 'test_init'

at_exit do
  ENV['LOG_LEVEL'] = 'fubar'
  ENV['LOGGER'] = 'on'
  ENV['LOG_METADATA'] = 'off'
  logger = Telemetry::Logger.get __FILE__
  logger.debug " "
  logger.warn "WARNING: event_store-entity_store is closed for elaboration"
  logger.debug " "
  logger.fail "This library is scheduled for an overhaul. Elaboration of this library will cause that work to have longer delays and greater cost."
  logger.debug " "
  logger.fubar "Issues:"
  logger.fubar "- Reify refresh policies as classes, rather than modules"
  logger.fubar "- Understand lifecycle and object allocation issues"
  logger.fubar "- Review design ethos in its entirety"
  logger.fubar "[Nathan Ladd, Mon Mar 7 2016]"
  logger.fubar "[Scott Bellware, Tue Mar 8 2016]"
  logger.debug " "
end

TestBench::Runner.(
  'bench/**/*.rb',
  exclude_pattern: %r{/skip\.|(?:_init\.rb|\.sketch\.rb|_sketch\.rb|\.skip\.rb)\z}
) or exit 1
