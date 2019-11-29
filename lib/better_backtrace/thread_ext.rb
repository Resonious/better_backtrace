# frozen_string_literal: true

module BetterBacktrace
  # Overrides Thread.new to make it register new threads with betterbacktrace
  module ThreadExt
    def new(*args)
      result = super(*args)
      BetterBacktrace.enable result
      result
    end
  end
end
