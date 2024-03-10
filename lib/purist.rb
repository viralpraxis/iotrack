# frozen_string_literal: true

require_relative 'purist/configuration'
require_relative 'purist/errors'
require_relative 'purist/handler'
require_relative 'purist/matcher'
require_relative 'purist/version'

module Purist
  TRACE_POINT_TYPES = %i[call c_call].freeze
  TRACE_HANDLER = proc do |trace_point|
    next unless Purist::Matcher.match?(configuration.trace_targets, trace_point)

    Purist.handler.call(trace_point)
  end

  def self.trace(&block)
    return unless block

    TracePoint
      .new(*TRACE_POINT_TYPES, &TRACE_HANDLER)
      .enable(&block)
  end

  def self.handler
    @handler ||= Purist::Handler.build(configuration.action_on_purity_violation)
  end

  def self.configuration
    @configuration ||= Purist::Configuration.instance
  end
end
