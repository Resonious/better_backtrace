# frozen_string_literal: true

module BetterBacktrace
  # Frame
  class Frame < Struct.new(:file, :line, :method, :frame_binding, :klass)
    def initialize(*args)
      super(*args)
    end

    def to_s
      locals = frame_binding.local_variables.map do |var_name|
        value = frame_binding.local_variable_get(var_name)
        begin
          "#{var_name}: #{truncate(value.inspect)}"
        rescue StandardError => e
          "<#{e.class} during inspect>"
        end
      end

      if klass.nil? && method.nil?
        "#{file}:#{line} yield(#{locals.join(', ')})"
      else
        "#{file}:#{line} #{klass}##{method}(#{locals.join(', ')})"
      end
    end

    private

    def truncate(string, max = 50, dots = 3)
      return string if string.size <= max

      string[0...(max - dots)] + ('.' * dots)
    end
  end
end
