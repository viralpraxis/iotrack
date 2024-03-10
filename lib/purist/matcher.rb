# frozen_string_literal: true

module Purist
  class Matcher
    def self.match?(specification, trace_point)
      specification.key? [trace_point.defined_class, trace_point.callee_id]
    end
  end
end
