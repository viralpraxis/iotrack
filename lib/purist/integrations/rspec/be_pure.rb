# frozen_string_literal: true

module Purist
  module Integrations
    module RSpec
      class BePure
        def supports_value_expectations?
          false
        end

        def supports_block_expectations?
          true
        end

        def matches?(block)
          Purist.trace { block.call }

          true
        rescue Purist::Errors::PurityViolationError => e
          @purist_exception = e

          false
        end

        def description
          'block to be pure'
        end

        def description_when_negated
          'block to be impure'
        end

        def failure_message
          "expected #{description}, detected impure #{purist_exception.trace_point.inspect}"
        end

        def failure_message_when_negated
          "expected #{description_when_negated}, but no side-effects were detected"
        end

        private

        attr_reader :purist_exception
      end
    end
  end
end
