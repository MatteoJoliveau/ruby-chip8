module Chip8
  class Opcode
    attr_reader :fun, :desc, :type, :format

    def initialize(format, type, desc, fun)
      @format = format
      @type = type
      @desc = desc
      @fun = fun
    end

  end
end