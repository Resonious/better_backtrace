# frozen_string_literal: true

module BetterBacktrace
  # Stack frame container
  class Trace
    Frame = Struct.new(:file, :line, :method, :binding, :klass) do
      def to_s
        vars = binding.local_variables.map do |var_name|
          value = binding.local_variable_get(var_name)
          begin
            "#{var_name}: #{value.inspect}"
          rescue StandardError
            '<error inspecting>'
          end
        end

        "#{file}:#{line} #{klass}##{method}(#{vars.join(', ')})"
      end
    end

    attr_reader :frames

    def initialize
      @frames = []
    end

    def trace_func(event, file, line, method_name, binding, klass)
      case event
      when 'call', 'class'
        @frames.push Frame.new(file, line, method_name, binding, klass)
      when 'return', 'end'
        @frames.pop
      end
    end
  end
end
