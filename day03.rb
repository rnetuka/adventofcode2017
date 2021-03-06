# --- Day 3: Spiral Memory ---
#
# You come across an experimental new kind of memory stored on an infinite two-dimensional grid.
#
# Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and then counting up while
# spiraling outward. For example, the first few squares are allocated like this:
#
# 17  16  15  14  13
# 18   5   4   3  12
# 19   6   1   2  11
# 20   7   8   9  10
# 21  22  23---> ...
#
# While this is very space-efficient (no squares are skipped), requested data must be carried back to square 1 (the
# location of the only access port for this memory system) by programs that can only move up, down, left, or right.
# They always take the shortest path: the Manhattan Distance between the location of the data and square 1.
#
# For example:
# Data from square 1 is carried 0 steps, since it's at the access port.
# Data from square 12 is carried 3 steps, such as: down, left, left.
# Data from square 23 is carried only 2 steps: up twice.
# Data from square 1024 must be carried 31 steps.
#
# How many steps are required to carry the data from the square identified in your puzzle input all the way to
# the access port?
#
# Your puzzle input is 277678.
#
# --- Part Two ---
#
# As a stress test on the system, the programs here clear the grid and then store the value 1 in square 1. Then, in
# the same allocation order as shown above, they store the sum of the values in all adjacent squares, including
# diagonals.
#
# So, the first few squares' values are chosen as follows:
# Square 1 starts with the value 1.
# Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
# Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
# Square 4 has all three of the aforementioned squares as neighbors and stores the sum of their values, 4.
# Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.
#
# Once a square is written, its value does not change. Therefore, the first few squares would receive the following
# values:
# 147  142  133  122   59
# 304    5    4    2   57
# 330   10    1    1   54
# 351   11   23   25   26
# 362  747  806--->   ...
#
# What is the first value written that is larger than your puzzle input?

class Coordinates

  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def eql?(other)
    @x == other.x and @y == other.y
  end

  def hash
    [@x, @y].hash
  end

end

class SpiralMemory

  attr_accessor :write_values

  def initialize
    @coordinates = [[0, 0]]
    @squares = {Coordinates.new(0, 0) => 1}
    @values = {1 => 1}
    @last_x = 0
    @last_y = 0
    @iteration = 0
    @operation_x = -> (coord) { coord + 1 }
    @operation_y = -> (coord) { coord - 1 }
    @write_values = false
  end

  # 1* x += 1
  # 1* y -= 1
  # 2* x -= 1
  # 2* y += 1
  # 3* x += 1
  # 3* y -= 1
  # 4* x -= 1
  # 4* y += 1
  # 5* x += 1
  # 5* y -= 1
  # 6* x -= 1
  def allocate_next_iteration
    @iteration += 1

    @iteration.times do
      square = last_square + 1
      @last_x = @operation_x.call(@last_x)
      allocate(square, @last_x, @last_y)
    end

    @iteration.times do
      square = last_square + 1
      @last_y = @operation_y.call(@last_y)
      allocate(square, @last_x, @last_y)
    end

    @operation_x, @operation_y = @operation_y, @operation_x
  end

  def allocate(square, x, y)
    @coordinates.append([x, y])
    @squares[Coordinates.new(x, y)] = square
    if write_values
      @values[square] = neighbors(square).inject(0) { |sum, neighbor| sum + @values[neighbor] }
    end
  end

  def allocate_until(square)
    while square > last_square
      allocate_next_iteration
    end
  end

  def coordinates(square)
    @coordinates[square - 1]
  end

  def square_at(x, y)
    @squares[Coordinates.new(x, y)]
  end

  def last_square
    @squares.length
  end

  def values
    @values.values
  end

  def neighbors(square)
    neighbors = []
    x, y = coordinates(square)
    [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]].each do |vector|
      dx, dy = vector[0], vector[1]
      neighbor = square_at(x + dx, y + dy)
      if neighbor
        neighbors.append(neighbor)
      end
    end
    neighbors
  end

end

def solution_1
  input = 277_678
  memory = SpiralMemory.new
  memory.allocate_until(input)
  x, y = memory.coordinates(input)
  x + y
end

def solution_2
  input = 277_678
  memory = SpiralMemory.new
  memory.write_values = true
  while memory.values.max < input
    memory.allocate_next_iteration
  end
  memory.values.each do |value|
    if value > input
      return value
    end
  end
end

puts "Day 3"
puts " - How many steps are required? #{solution_1}"
puts " - What is the first value written larger than the input? #{solution_2}"