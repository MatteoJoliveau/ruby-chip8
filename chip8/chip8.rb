module Chip8
  class Chip8

    attr_reader :instructionset, :pc, :ir, :sp, :opcode, :v, :memory

    def initialize
      # noinspection RubyInstanceVariableNamingConvention
      @v = [0]*16 # regiters
      @stack = []
      @delay_timer = 0
      @sound_time = 0
      @memory = [0]*64*64
      @instructionset = {
          0x000E => Opcode.new(nil, nil, nil, -> opcode {
            puts 'IMPLEMENT RETURN FROM SUBROUTINE'
          }),
          0x0000 => Opcode.new('0x00E0', :Display, 'Clear display', -> opcode {
            puts 'IMPLEMENT CLEAR DISPLAY'
          }),
          0x6000 => Opcode.new('0x6XNN', :Const, '	Sets VX to NN.', -> opcode {
            @v[(opcode & 0x0F00) >> 8] = ((opcode & 0x00F0) >> 4)
          }),
          0xA000 => Opcode.new('0xANNN', :MEM, 'Sets index register to the address NNN.', -> opcode {
            puts "Received 0x#{opcode.to_s 16}, setting ir to 0x#{(opcode & 0x0FFF).to_s 16}"
            @ir = opcode & 0x0FFF
            @pc += 2
          }),
          0x2000 => Opcode.new('0x2NNN', :Flow, 'Calls subroutine at NNN', -> opcode {
            @stack[@sp] = @pc
            @sp += 1
            @pc = opcode & 0x0FFF
          }),
          0x8000 => Opcode.new('0x8XY0', :Assing, 'Sets VX to the value of VY.', -> opcode {
            @v[(opcode & 0x0F00) >> 8] = @v[(opcode & 0x00F0) >> 4]
            @pc += 2
          }),
          0x8001 => Opcode.new('0x8XY1', :BitOp, 'Sets VX to VX or VY.', -> opcode {
            @v[(opcode & 0x0F00) >> 8] = @v[(opcode & 0x00F0) >> 4] | @v[(opcode & 0x0F00) >> 8]
            @pc += 2
          }),
          0x8002 => Opcode.new('0x8XY2', :BitOp, 'Sets VX to VX and VY.', -> opcode {
            @v[(opcode & 0x0F00) >> 8] = @v[(opcode & 0x00F0) >> 4] & @v[(opcode & 0x0F00) >> 8]
            @pc += 2
          }),
          0x8003 => Opcode.new('0x8XY3', :BitOp, 'Sets VX to VX xor VY.', -> opcode {
            @v[(opcode & 0x0F00) >> 8] = @v[(opcode & 0x00F0) >> 4] ^ @v[(opcode & 0x0F00) >> 8]
            @pc += 2
          }),
          0x8004 => Opcode.new('0x8XY4', :Math, 'Adds VY to VX. VF is set to 1 when there\'s a carry, and to 0 when there isn\'t.', -> opcode {
            if @v[(opcode & 0x00F0) >> 4] > (0xFF - @v[(opcode & 0x0F00) >> 8])
              @v[0xF] = 1; # carry
            else
              @v[0xF] = 0
              @v[(opcode & 0x0F00) >> 8] += @v[(opcode & 0x00F0) >> 4]
              @pc +=2
            end
          }),
          0x0033 => Opcode.new('0xFX33', :BCD, '', -> opcode {
            @memory[I] = @v[(opcode & 0x0F00) >> 8] / 100
            @memory[I + 1] = (@v[(opcode & 0x0F00) >> 8] / 10) % 10
            @memory[I + 2] = (@v[(opcode & 0x0F00) >> 8] % 100) % 10
            @pc += 2
          }),
      }
    end

    def decode opcode
      puts "Processing #{format_op opcode}"
      op = opcode & 0xF000
      puts "First 4 bits are #{format_op op}"
      case op
        when 0x0000
          op2 = opcode & 0xF00F
          puts "Starts with 0, looking further #{format_op op2}"
          get_opcode op2, opcode
        when 0x8000
          op2 = opcode & 0xF00F
          puts "Starts with 8, looking further #{format_op op2}"
          get_opcode op2, opcode
        else
          get_opcode op, opcode
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

      op1 = @memory[@pc]
      op2 = @memory[@pc + 1]
      hex_opcode = op1 << 8 | op2

      # decode opcode
      opcode = decode hex_opcode

      # execute opcode
      opcode.fun.call hex_opcode

      # update timers
      if @delay_timer > 0
        @delay_timer -= 1
      end

      if @sound_timer > 0
        if @sound_timer == 1
          puts 'BEEP!'
          @sound_timer -= 1
        end
      end
    end

    def test d
      puts d
    end

    def get_opcode(key, opcode)
      if @instructionset.key? key
        @instructionset[key]
      else
        puts "Unknown opcode #{format_op opcode}"
      end
    end

    def format_op opcode
      "0x#{opcode.to_s 16}"
    end

    private :format_op
    end
  end