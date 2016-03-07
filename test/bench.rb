require_relative 'test_init'

at_exit do
  fail "Do not further elaborate on this library until we break out the refresh policies into classes that can be dependencies; the design in general needs a thorough review" # [Nathan Ladd, Mon Mar 7 2016]
end

TestBench::Runner.(
  'bench/**/*.rb',
  exclude_pattern: %r{/skip\.|(?:_init\.rb|\.sketch\.rb|_sketch\.rb|\.skip\.rb)\z}
) or exit 1
