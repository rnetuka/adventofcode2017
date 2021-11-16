require 'prime'

class Instruction

  attr_reader :name, :operand_a, :operand_b

  def initialize(name, operand_a, operand_b = nil)
    @name = name
    @operand_a = operand_a
    @operand_b = operand_b
  end

  def Instruction.parse(string)
    parts = string.split
    Instruction.new(parts[0], parse_operand(parts[1]), parse_operand(parts[2]))
  end

end

class Program

  attr_reader :mul_count

  def initialize
    @registers = {}
    @registers.default = 0
    @mul_count = 0
  end

  def evaluate(operand)
    operand.is_a?(Integer) ? operand : @registers[operand]
  end

  def run(instructions)
    @instructions = instructions
    @position = 0
    while @position < @instructions.length
      self.next
    end
  end

  def next
    instruction = @instructions[@position]
    case instruction.name
    when 'set'
      register = instruction.operand_a
      value = evaluate(instruction.operand_b)
      @registers[register] = value
    when 'sub'
      register = instruction.operand_a
      value = evaluate(instruction.operand_b)
      @registers[register] -= value
    when 'mul'
      register = instruction.operand_a
      value = evaluate(instruction.operand_b)
      @registers[register] *= value
      @mul_count += 1
    when 'jnz'
      value = evaluate(instruction.operand_a)
      offset = evaluate(instruction.operand_b)
      if value != 0
        @position += offset
        return
      end
    end
    @position += 1
  end

end

def read_instructions
  File.open('input/day23.txt').readlines.map { |string| Instruction.parse(string) }
end

def parse_operand(string)
  /-?[0-9]+/.match?(string) ? string.to_i : string
end

def solution_1
  prog = Program.new
  prog.run(read_instructions)
  prog.mul_count
end

def solution_2
  b = 108400  # starting value of register B
  c = 125400  # constant value of register C
  h = 1       # when line 25 (jnz F 2) is first reached, F is set to 0 (because B is not a prime)
  steps = (c - b) / 17  # the loop runs 1000 times
  steps.times do
    # for H to increase, F needs to be set to 0
    # F gets set to 0 if D*E == B for some D and E (both starting at 2,3,... until the value of B)
    # i.e. F gets set to 0 only if B is not a prime number
    h += 1 unless Prime.prime?(b)
    b += 17
  end
  h
end

puts 'Day 23'
puts " - How many times is the MUL instruction invoked? #{solution_1}"
puts " - What value would be left in register H? #{solution_2}"