# frozen_string_literal: true

module BetterBacktrace
  # Frame
  class Frame < Struct.new(:file, :line, :method, :frame_binding, :klass)
    def initialize(*args)
      super(*args)
    end

    def to_s
      if klass.nil? && method.nil?
        # TODO class body frame looks like "yield()"...
        "#{file}:#{line} yield(#{format_locals})"
      else
        "#{file}:#{line} #{klass}##{method}(#{format_locals})"
      end
    end

    def format_locals
      components = []
      locals_hash.each do |name, value|
        components << "#{name}: #{value}"
      end
      components.join(', ')
    end

    def locals_hash
      frame_binding.local_variables.map do |var_name|
        begin
          [var_name, truncate(frame_binding.local_variable_get(var_name).inspect)]
        rescue StandardError => e
          [var_name, "<#{e.class} during inspect>"]
        end
      end.to_h
    end

    private

    def truncate(string, max = 50, dots = 3)
      return string if string.size <= max

      string[0...(max - dots)] + ('.' * dots)
    end
  end
end
