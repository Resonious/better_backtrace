# frozen_string_literal: true

module BetterBacktrace
  # Stack frame container
  class Trace
    def initialize
      @frames = []

      @exception = nil

      @trace_points = []
      @trace_points << TracePoint.new(:call, :b_call, :class, &method(:push))
      @trace_points << TracePoint.new(:return, :b_return, :end, &method(:pop))
      # @trace_points << TracePoint.new(:raise, &method(:modify_exception))
    end

    def start
      @trace_points.each(&:enable)
    end

    def stop
      @trace_points.each(&:disable)
    end

    def backtrace
      @frames.map(&:to_s)
    end

    private

    def padding
      ' ' * @frames.size
    end

    def push(_tp)
      @frames.clear
    end

    def pop(tp)
      caller = caller_locations(1..1).first
      # puts "#{padding}POP(#{tp.event}) #{caller}"

      @frames << Frame.new(
        tp.path, caller.lineno, tp.method_id,
        tp.binding, tp.defined_class
      )
    end

    # def modify_exception(tp)
    #   puts "#{padding}RAISE (#{@frames.size} frames)"
    #   @exception = tp.raised_exception
    # end
  end
end
