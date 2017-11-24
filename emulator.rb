require_relative 'chip8/chip8'
require_relative 'chip8/opcodes'

chip8 = Chip8::Chip8.new


chip8.init


sum = 0xA2 << 8 | 0xF0

chip8.decode sum
puts ''
chip8.decode 0x00E0
puts ''
chip8.decode 0x00EE