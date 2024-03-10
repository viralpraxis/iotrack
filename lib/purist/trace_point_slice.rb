# frozen_string_literal: true

module Purist
  class TracePointSlice
    def self.call(trace_point)
      {
        path: trace_point.path,
        lineno: trace_point.lineno,
        module_name: trace_point.defined_class,
        method_name: trace_point.callee_id,
        backtrace: trace_point.binding.send(:caller)
      }
    end
  end
end
