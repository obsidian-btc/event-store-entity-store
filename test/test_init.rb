ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_COLOR'] ||= 'on'
ENV['LOG_LEVEL'] ||= 'trace'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'securerandom'
require 'runner'

require 'event_store/entity_store/controls'

Telemetry::Logger::AdHoc.activate
