ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_COLOR'] ||= 'on'
ENV['LOG_LEVEL'] ||= 'trace'

puts RUBY_DESCRIPTION

require_relative '../init.rb'
require 'securerandom'
require 'runner'

require 'event_store/entity_store/controls'

TestLogger = Telemetry::Logger.get 'Test Output'

def logger(name)
  name = name.split('/').last
  Telemetry::Logger.get "-- TEST -- #{name}"
end
