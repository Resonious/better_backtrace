# frozen_string_literal: true

require 'better_backtrace/version'
require 'better_backtrace/frame'
require 'better_backtrace/trace'
require 'better_backtrace/thread_ext'

# Improves backtraces by including class names and method arguments
module BetterBacktrace
  class Error < StandardError; end

  class << self
    def enable(thread = Thread.current)
      thread[:_better_backtrace_trace] = BetterBacktrace::Trace.new
      thread[:_better_backtrace_trace].start
    end

    def disable(thread = Thread.current)
      return unless (trace = thread[:_better_backtrace_trace])

      trace.stop
      thread[:_better_backtrace_trace] = nil
    end

    def enabled?(thread = Thread.current)
      !!thread[:_better_backtrace_trace]
    end

    def setup
      enable
      Thread.singleton_class.prepend ThreadExt
    end
  end
end

# Set up by default for now
BetterBacktrace.setup

Thread.prepend BetterBacktrace::ThreadExt
