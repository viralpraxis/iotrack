# frozen_string_literal: true

require_relative 'trace_point_slice'

module Purist
  module Handler
    def self.build(mode)
      case mode&.to_sym
      when :raise then Raise.new
      when nil then nil
      else raise ArgumentError, "Unexpected mode `#{mode.inspect}`"
      end
    end

    class Base; end # rubocop:disable Lint/EmptyClass

    class Raise < Base
      def call(trace_point)
        raise Purist::Errors::PurityViolationError.new(
          trace_point: TracePointSlice.call(trace_point)
        )
      end
    end
  end
end
