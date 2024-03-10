# frozen_string_literal: true

module Purist
  module Errors
    class Error < StandardError; end

    class PurityViolationError < Error
      attr_reader :trace_point

      def initialize(message = nil, trace_point:)
        @trace_point = trace_point

        super(message || trace_point.reject { |key| key == :backtrace }.inspect)
      end
    end
  end
end
