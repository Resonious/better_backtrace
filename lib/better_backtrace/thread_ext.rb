# frozen_string_literal: true

module BetterBacktrace
  # Overrides Thread.new to make it register new threads with betterbacktrace
  module ThreadExt
    def new(*args, &block)
      result = super(*args, &block)
      BetterBacktrace.enable result
      result
    end
  end
end
