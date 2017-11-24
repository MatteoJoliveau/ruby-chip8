# SYSTEM MEMORY MAP
# 0x000-0x1FF - Chip 8 interpreter (contains font set in emu)
# 0x050-0x0A0 - Used for the built in 4x5 pixel font set (0-F)
# 0x200-0xFFF - Program ROM and work RAM

require_relative 'chip8/chip8'

memory = []                     # 4096 bytes of RAM
videomemory = [0]*64*32         # 2048 pixles
opcode = 0
stack = []                      # 16 levels
sp = 0                          # stack pointer
v = []                          # 16 8-bit registers. From V0 to VF

ir = 0x0                        # instruction register, from 0x000 to 0xFFF
pc = 0x0                        # program counter, from 0x000 to 0xFFF

delay_timer = 0
sound_time = 0                  # when reach 0, buzz from the speaker

key = []                        # 16 keys in the keyboard, from 0x0 to 0xF

chip8 = Chip8::Chip8.new

