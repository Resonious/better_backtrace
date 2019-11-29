# frozen_string_literal: true

module BetterBacktrace
  # Stack frame container
  class Trace
    def initialize
      @frames = []

      @backtrace = nil
      @exception = nil

      @trace_points = []
      @trace_points << TracePoint.new(:call, :b_call, :class, &method(:push))
      @trace_points << TracePoint.new(:return, :b_return, :end, &method(:pop))
      @trace_points << TracePoint.new(:raise, &method(:modify_exception))
    end

    def start
      @trace_points.each(&:enable)
    end

    def stop
      @trace_points.each(&:disable)
    end

    private

    def padding
      ' ' * @frames.size
    end

    def push(tp)
      caller = caller_locations(1..1).first
      # puts "#{padding}PUSH(#{tp.event}) #{caller}"

      @frames << Frame.new(
        tp.path, caller.lineno, tp.method_id,
        tp.binding, tp.defined_class
      )
    end

    def pop(tp)
      popped = @frames.pop
      caller = caller_locations(1..1).first

      # Follow unwind
      if @backtrace
        popped.line = caller.lineno
        @backtrace << popped

        set_and_clear_backtrace if @frames.empty?
      end

      # puts "#{padding}POP(#{tp.event}) #{caller}"
    end

    def modify_exception(tp)
      # puts "#{padding}RAISE (#{@frames.size} frames)"
      @exception = tp.raised_exception
      @backtrace = []
    end

    def set_and_clear_backtrace
      @exception.set_backtrace @backtrace.map(&:to_s)
      @backtrace = nil
      @exception = nil
    end
  end
end
