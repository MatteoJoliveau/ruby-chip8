module Chip8
  class Chip8

    attr_reader :codemap, :pc, :ir, :sp, :opcode

    def initialize
      @codemap = {
          0x000E => Opcode.new(nil, nil, nil, -> opcode {
            puts 'IMPLEMENT RETURN FROM SUBROUTINE'
          }),
          0x0000 => Opcode.new('0x00E0', :Display, 'Clear display', -> opcode {
            puts 'IMPLEMENT CLEAR DISPLAY'
          }),
          0xA000 => Opcode.new('0xANNN', :MEM, 'Sets index register to the address NNN.', -> opcode {
            puts "Received 0x#{opcode.to_s 16}, setting ir to 0x#{(opcode & 0x0FFF).to_s 16}"
            @ir = opcode & 0x0FFF
            @pc += 2
          }),
      }
    end

    def decode opcode
      puts "Processing #{format_op opcode}"
      op = opcode & 0xF000
      puts "First 4 bits are #{format_op op}"
      if op === 0x0000
        op2 = opcode & 0x000F
        puts "Starts with 0, looking further #{format_op op2}"
        if @codemap.key? op2
          @codemap[op2].fun.call(opcode)
        end
      else
        if @codemap.key? op
          @codemap[op].fun.call(opcode)
        end
      end
      puts "Decoded #{format_op opcode}"
    end

    def init
      @pc = 0x200 # Program counter starts at 0x200
      @opcode = 0 # Reset current opcode
      @ir = 0 # Reset index register
      @sp = 0

    end

    def tick
      # fetch next opcode
      # decode opcode
      # execute opcode
      # update timers
    end

    def test d
      puts d
    end

    def format_op opcode
      "0x#{opcode.to_s 16}"
    end

    private :format_op
  end
end