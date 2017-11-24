require_relative 'chip8/chip8'
require_relative 'chip8/opcodes'

chip8 = Chip8::Chip8.new


chip8.init


sum = 0xA2 << 8 | 0xF0

# chip8.decode sum
# puts ''
# chip8.decode 0x00E0
# puts ''
# chip8.decode 0x2123

# chip8.decode 0x00EE
# puts ''
# chip8.v[2] = 0x2
# chip8.v[1] = 0x1
# puts chip8.v[1].to_s 16
# chip8.decode 0x8120
# puts chip8.v[1].to_s 16
# puts ''
# chip8.decode 0x6122

chip8.memory.unshift(0x6122)
chip8.memory.unshift(0x8120)
puts chip8.v[1].to_s 16
while true
  chip8.tick
  puts chip8.v[1].to_s 16
end