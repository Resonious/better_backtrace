# frozen_string_literal: true

require 'better_backtrace/version'
require 'better_backtrace/trace'
require 'better_backtrace/exception_ext'

# TODO
module BetterBacktrace
  class Error < StandardError; end
end

StandardError.prepend BetterBacktrace::ExceptionExt

set_trace_func(lambda do |event, file, line, method_name, binding, klass|
  trace = (Thread.current[:_better_backtrace_trace] ||= BetterBacktrace::Trace.new)
  trace.trace_func(event, file, line, method_name, binding, klass)
end)
