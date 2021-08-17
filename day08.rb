# --- Day 8: I Heard You Like Registers ---
#
# You receive a signal directly from the CPU. Because of your recent assistance with jump instructions, it would like
# you to compute the result of a series of unusual register instructions.
#
# Each instruction consists of several parts: the register to modify, whether to increase or decrease that register's
# value, the amount by which to increase or decrease it, and a condition. If the condition fails, skip the instruction
# without modifying the register. The registers all start at 0. The instructions look like this:
# b inc 5 if a > 1
# a inc 1 if b < 5
# c dec -10 if a >= 1
# c inc -20 if c == 10
#
# These instructions would be processed as follows:
# Because a starts at 0, it is not greater than 1, and so b is not modified.
# a is increased by 1 (to 1) because b is less than 5 (it is 0).
# c is decreased by -10 (to 10) because a is now greater than or equal to 1 (it is 1).
# c is increased by -20 (to -10) because c is equal to 10.
# After this process, the largest value in any register is 1.
#
# You might also encounter <= (less than or equal to) or != (not equal to). However, the CPU doesn't have the bandwidth
# to tell you what all the registers are named, and leaves that to you to determine.
#
# What is the largest value in any register after completing the instructions in your puzzle input?
#
# --- Part Two ---
#
# To be safe, the CPU also needs to know the highest value held in any register during this process so that it can
# decide how much memory to allocate to these operations. For example, in the above instructions, the highest value ever
# held was 10 (in register c after the third instruction was evaluated).

require 'strscan'

class Instruction

  attr_reader :condition, :operation

  def initialize(condition, operation)
    @condition = condition
    @operation = operation
  end

  def Instruction.parse(string)
    parts = string.split('if')
    condition = Operation.parse(parts[1])
    operation = Operation.parse(parts[0])
    Instruction.new(condition, operation)
  end

end


class Operation

  @@operations = {
    'inc' => lambda { |a, b, registers| registers[a] += b },
    'dec' => lambda { |a, b, registers| registers[a] -= b },
    '<'   => lambda { |a, b, registers| registers[a] < b },
    '>'   => lambda { |a, b, registers| registers[a] > b },
    '<='  => lambda { |a, b, registers| registers[a] <= b },
    '>='  => lambda { |a, b, registers| registers[a] >= b },
    '=='  => lambda { |a, b, registers| registers[a] == b },
    '!='  => lambda { |a, b, registers| registers[a] != b }
  }

  def initialize(operator, a, b)
    unless @@operations.key?(operator)
      raise "Unknown operation #{operator}"
    end
    @operator = operator
    @operand_a = a
    @operand_b = b
  end

  def Operation.parse(string)
    parts = string.split
    operator = parts[1]
    operand_a = parts[0]
    operand_b = parts[2].to_i
    Operation.new(operator, operand_a, operand_b)
  end

  def evaluate(registers)
    registers[@operand_a] ||= 0
    @@operations[@operator].call(@operand_a, @operand_b, registers)
  end

end


class CPU

  attr_reader :registers

  def initialize
    @registers = {}
  end

  def process(instruction)
    if instruction.condition.evaluate(@registers)
      instruction.operation.evaluate(@registers)
    end
  end

  def run(instructions)
    instructions.each do |instruction|
      process(instruction)
    end
  end

end


def read_instructions
  File.open('input/day08.txt').readlines.each.map { |line| Instruction.parse(line) }
end

def solution_1
  cpu = CPU.new
  cpu.run(read_instructions)
  cpu.registers.values.max
end

def solution_2
  cpu = CPU.new
  max_value = 0
  read_instructions.each do |instruction|
    cpu.process(instruction)
    max_value = [max_value, cpu.registers.values.max].max
  end
  max_value
end

puts "Day 8"
puts " - What is the largest value in any register: #{solution_1}"
puts " - What is the highest value held in any register during this process: #{solution_2}"