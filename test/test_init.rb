fail "Do not further elaborate on this library until we break out the refresh policies into classes that can be dependencies; actually the design in general needs a thorough review" # [Nathan Ladd, Mon Mar 7 2016]
ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_COLOR'] ||= 'on'

if ENV['LOG_LEVEL']
  ENV['LOGGER'] ||= 'on'
else
  ENV['LOG_LEVEL'] ||= 'trace'
end

ENV['LOGGER'] ||= 'off'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'securerandom'
require 'test_bench'; TestBench.activate
require 'event_store/entity_store/controls'

Telemetry::Logger::AdHoc.activate
