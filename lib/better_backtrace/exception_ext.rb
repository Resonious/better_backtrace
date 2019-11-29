# frozen_string_literal: true

module BetterBacktrace
  # Overrides Exception#backtrace
  module ExceptionExt
    def initialize(*args)
      result = super
      if BetterBacktrace.enabled?
        set_backtrace(Thread.current[:_better_backtrace_trace].backtrace)
      end
      result
    end
  end
end
