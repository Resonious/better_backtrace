# frozen_string_literal: true

module BetterBacktrace
  # Overrides Exception#backtrace
  module ExceptionExt
    def backtrace
      if BetterBacktrace.enabled?
        # TODO
      else
        super
      end
    end
  end
end
