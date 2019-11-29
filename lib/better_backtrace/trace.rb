# frozen_string_literal: true

module BetterBacktrace
  # Stack frame container
  class Trace
    def initialize
      @frames = []

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
      caller = caller_locations(2..2).first
      return if caller.nil?
      #puts "#{padding}PUSH(#{tp.event}) #{caller}"

      @frames << Frame.new(
        tp.path, caller.lineno, tp.method_id,
        tp.binding, tp.defined_class
      )
    end

    def pop(tp)
      @frames.pop
      #caller = caller_locations(2..2).first
      #puts "#{padding}POP(#{tp.event}) #{caller}"
    end

    def modify_exception(tp)
      push(tp)
      #puts "#{padding}RAISE (#{@frames.size} frames)"
      tp.raised_exception.set_backtrace @frames.reverse.map(&:to_s)
    end
  end
end
