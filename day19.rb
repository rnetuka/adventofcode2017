# --- Day 19: A Series of Tubes ---
#
# Somehow, a network packet got lost and ended up here. It's trying to follow a routing diagram (your puzzle input), but
# it's confused about where to go.
#
# Its starting point is just off the top of the diagram. Lines (drawn with |, -, and +) show the path it needs to take,
# starting by going down onto the only line connected to the top of the diagram. It needs to follow this path until it
# reaches the end (located somewhere within the diagram) and stop there.
#
# Sometimes, the lines cross over each other; in these cases, it needs to continue going the same direction, and only
# turn left or right when there's no other option. In addition, someone has left letters on the line; these also don't
# change its direction, but it can use them to keep track of where it's been. For example:
#      |
#      |  +--+
#      A  |  C
#  F---|----E|--+
#      |  |  |  D
#      +B-+  +--+
#
# Given this diagram, the packet needs to take the following path:
# - Starting at the only line touching the top of the diagram, it must go down, pass through A, and continue onward to the
#   first +.
# - Travel right, up, and right, passing through B in the process.
# - Continue down (collecting C), right, and up (collecting D).
# - Finally, go all the way left through E and stopping at F.
#
# Following the path to the end, the letters it sees on its path are ABCDEF.
#
# The little packet looks up at you, hoping you can help it find the way. What letters will it see (in the order it
# would see them) if it follows the path? (The routing diagram is very wide; make sure you view it without line
# wrapping.)
#
# --- Part Two ---
#
# The packet is curious how many steps it needs to go.
#
# For example, using the same routing diagram from the example above...
#
#      |
#      |  +--+
#      A  |  C
#  F---|--|-E---+
#      |  |  |  D
#      +B-+  +--+
#
# ...the packet would go:
# 6 steps down (including the first line at the top of the diagram).
# 3 steps right.
# 4 steps up.
# 3 steps right.
# 4 steps down.
# 3 steps right.
# 2 steps up.
# 13 steps left (including the F it stops on).
# This would result in a total of 38 steps.
#
# How many steps does the packet need to go?

class Coordinates

  attr_reader :row, :column

  def initialize(row, column)
    @row = row
    @column = column
  end

  def next(direction)
    { :up    => -> { Coordinates.new(@row - 1, @column) },
      :down  => -> { Coordinates.new(@row + 1, @column) },
      :left  => -> { Coordinates.new(@row, @column - 1) },
      :right => -> { Coordinates.new(@row, @column + 1) }
    }[direction].call
  end

end

def reverse(direction)
  { :up => :down, :left => :right, :down => :up, :right => :left }[direction]
end

class Pipes

  attr_reader :grid
  attr_accessor :packet, :packet_steps

  def initialize
    @grid = []
    @packet = nil
    @packet_facing = :down
    @packet_waypoints = []
    @packet_steps = 0
  end

  def Pipes.load(path)
    pipes = Pipes.new
    lines = File.open(path).readlines
    lines.each do |line|
      pipes.grid.append(line.chars)
    end
    pipes.packet = Coordinates.new(0, lines[0].index('|'))
    pipes.packet_steps = 1
    pipes
  end

  def pipe_at(coordinates)
    pipe = @grid[coordinates.row][coordinates.column]
    pipe == ' ' ? nil : pipe
  end

  def move_packet
    next_coordinates = @packet.next(@packet_facing)
    next_pipe = pipe_at(next_coordinates)
    if /[A-Z]/.match?(next_pipe)
      @packet_waypoints.append(next_pipe)
    elsif next_pipe == '+'
      directions = [:up, :right, :down, :left]
      directions.delete(reverse(@packet_facing))
      directions.each do |direction|
        if pipe_at(next_coordinates.next(direction))
          @packet_facing = direction
          break
        end
      end
    end
    if pipe_at(next_coordinates)
      @packet = next_coordinates
      @packet_steps += 1
    end
  end

  def packet_waypoints
    @packet_waypoints.join
  end

  def packet_in_finish?
    directions = [:up, :right, :down, :left]
    directions.delete(reverse(@packet_facing))
    directions.all? { |direction| not pipe_at(@packet.next(direction)) }
  end

end

pipes = Pipes.load('input/day19.txt')
until pipes.packet_in_finish? do
  pipes.move_packet
end

puts 'Day 19'
puts " - What letters will it see? #{pipes.packet_waypoints}"
puts " - How many steps does the packet need to go? #{pipes.packet_steps}"
