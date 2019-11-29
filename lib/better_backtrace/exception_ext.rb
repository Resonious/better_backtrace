# frozen_string_literal: true

module BetterBacktrace
  # Overrides backtrace to use the "better" one
  module ExceptionExt
    def set_backtrace(*)
      exclude = "#{__FILE__}:#{__LINE__}"
      better = Thread.current[:_better_backtrace_trace]
        .frames
        .map(&:to_s)
        .reject { |b| b.include?(exclude) }
      super(better)
    end
  end
end
