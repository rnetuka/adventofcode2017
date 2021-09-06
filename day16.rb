# --- Day 16: Permutation Promenade ---
#
# You come upon a very unusual sight; a group of programs here appear to be dancing.
#
# There are sixteen programs in total, named a through p. They start by standing in a line: a stands in position 0, b
# stands in position 1, and so on until p, which stands in position 15.
#
# The programs' dance consists of a sequence of dance moves:
#
# Spin, written sX, makes X programs move from the end to the front, but maintain their order otherwise. (For example,
# s3 on abcde produces cdeab).
# Exchange, written xA/B, makes the programs at positions A and B swap places.
# Partner, written pA/B, makes the programs named A and B swap places.
#
# For example, with only five programs standing in a line (abcde), they could do the following dance:
# s1, a spin of size 1: eabcd.
# x3/4, swapping the last two programs: eabdc.
# pe/b, swapping programs e and b: baedc.
# After finishing their dance, the programs end up in order baedc.
#
# You watch the dance for a while and record their dance moves (your puzzle input). In what order are the programs
# standing after their dance?
#
# --- Part Two ---
#
# Now that you're starting to get a feel for the dance moves, you turn your attention to the dance as a whole.
#
# Keeping the positions they ended up in from their previous dance, the programs perform it again and again: including
# the first dance, a total of one billion (1000000000) times.
#
# In the example above, their second dance would begin with the order baedc, and use the same dance moves:
# s1, a spin of size 1: cbaed.
# x3/4, swapping the last two programs: cbade.
# pe/b, swapping programs e and b: ceadb.
# In what order are the programs standing after their billion dances?

require 'set'

class Programs

  def initialize
    @line = 'abcdefghijklmnop'.chars
  end

  def spin(n)
    @line.rotate!(-n)
  end

  def exchange(i, j)
    @line[i], @line[j] = @line[j], @line[i]
  end

  def partner(a, b)
    i = @line.index(a)
    j = @line.index(b)
    exchange(i, j)
  end

  def dance(moves)
    moves.each do |move|
      case move[0]
      when 's'
        n = move[1..-1].to_i
        spin(n)
      when 'x'
        parts = move[1..-1].split('/')
        i = parts[0].to_i
        j = parts[1].to_i
        exchange(i, j)
      when 'p'
        parts = move[1..-1].split('/')
        a = parts[0]
        b = parts[1]
        partner(a, b)
      end
    end
  end

  def to_s
    @line.join
  end

end

def read_moves
  File.open('input/day16.txt').readline.strip.split(',')
end

def solution_1
  programs = Programs.new
  programs.dance(read_moves)
  programs
end

def solution_2
  # after some time, programs might reach the same lineup as before
  history = solution_1.to_s
  programs = Programs.new
  moves = read_moves
  n = 0
  1_000_000_000.times do |i|
    programs.dance(moves)
    if i > 1 and history == programs.to_s
      # the programs reached the same lineup after n steps
      n = i
      break
    end
  end
  # the programs will reach the same state after every n steps (1*n steps already taken)
  m = (1_000_000_000 % n) - 1
  m.times { programs.dance(moves) }
  programs
end

puts 'Day 16'
puts " - In what order are the programs standing? #{solution_1}"
puts " - ... after their billion dances #{solution_2}"
