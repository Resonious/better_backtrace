# frozen_string_literal: true

module BetterBacktrace
  # Frame
  class Frame < Struct.new(:file, :line, :method, :locals, :klass)
    def initialize(*args)
      super(*args)

      # TODO actually I think this should be moved back into to_s...
      # the reason is: since we have to lump args in with locals,
      # we might as well show the values at the time of the exception.
      self.locals = locals.local_variables.map do |var_name|
        begin
          [var_name, truncate(locals.local_variable_get(var_name).inspect)]
        rescue StandardError => e
          [var_name, "<#{e.class} during inspect>"]
        end
      end.to_h
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
      locals.each do |name, value|
        components << "#{name}: #{value}"
      end
      components.join(', ')
    end

    private

    def truncate(string, max = 50, dots = 3)
      return string if string.size <= max

      string[0...(max - dots)] + ('.' * dots)
    end
  end
end
