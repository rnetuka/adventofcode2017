# --- Day 9: Stream Processing ---
#
# A large stream blocks your path. According to the locals, it's not safe to cross the stream at the moment because it's
# full of garbage. You look down at the stream; rather than water, you discover that it's a stream of characters.
#
# You sit for a while and record part of the stream (your puzzle input). The characters represent groups - sequences
# that begin with { and end with }. Within a group, there are zero or more other things, separated by commas: either
# another group or garbage. Since groups can contain other groups, a } only closes the most-recently-opened unclosed
# group - that is, they are nestable. Your puzzle input represents a single, large group which itself contains many
# smaller ones.
#
# Sometimes, instead of a group, you will find garbage. Garbage begins with < and ends with >. Between those angle
# brackets, almost any character can appear, including { and }. Within garbage, < has no special meaning.
#
# In a futile attempt to clean up the garbage, some program has canceled some of the characters within it using !:
# inside garbage, any character that comes after ! should be ignored, including <, >, and even another !.
#
# You don't see any characters that deviate from these rules. Outside garbage, you only find well-formed groups, and
# garbage always terminates according to the rules above.
#
# Here are some self-contained pieces of garbage:
# <>, empty garbage.
# <random characters>, garbage containing random characters.
# <<<<>, because the extra < are ignored.
# <{!>}>, because the first > is canceled.
# <!!>, because the second ! is canceled, allowing the > to terminate the garbage.
# <!!!>>, because the second ! and the first > are canceled.
# <{o"i!a,<{i<a>, which ends at the first >.
# Here are some examples of whole streams and the number of groups they contain:
#
# {}, 1 group.
# {{{}}}, 3 groups.
# {{},{}}, also 3 groups.
# {{{},{},{{}}}}, 6 groups.
# {<{},{},{{}}>}, 1 group (which itself contains garbage).
# {<a>,<a>,<a>,<a>}, 1 group.
# {{<a>},{<a>},{<a>},{<a>}}, 5 groups.
# {{<!>},{<!>},{<!>},{<a>}}, 2 groups (since all but the last > are canceled).
#
# Your goal is to find the total score for all groups in your input. Each group is assigned a score which is one more
# than the score of the group that immediately contains it. (The outermost group gets a score of 1.)
#
# {}, score of 1.
# {{{}}}, score of 1 + 2 + 3 = 6.
# {{},{}}, score of 1 + 2 + 2 = 5.
# {{{},{},{{}}}}, score of 1 + 2 + 3 + 3 + 3 + 4 = 16.
# {<a>,<a>,<a>,<a>}, score of 1.
# {{<ab>},{<ab>},{<ab>},{<ab>}}, score of 1 + 2 + 2 + 2 + 2 = 9.
# {{<!!>},{<!!>},{<!!>},{<!!>}}, score of 1 + 2 + 2 + 2 + 2 = 9.
# {{<a!>},{<a!>},{<a!>},{<ab>}}, score of 1 + 2 = 3.
#
# What is the total score for all groups in your input?
#
# --- Part Two ---
#
# Now, you're ready to remove the garbage.
#
# To prove you've removed it, you need to count all of the characters within the garbage. The leading and trailing <
# and > don't count, nor do any canceled characters or the ! doing the canceling.
#
# <>, 0 characters.
# <random characters>, 17 characters.
# <<<<>, 3 characters.
# <{!>}>, 2 characters.
# <!!>, 0 characters.
# <!!!>>, 0 characters.
# <{o"i!a,<{i<a>, 10 characters.
#
# How many non-canceled characters are within the garbage in your puzzle input?

require 'set'
require_relative 'state_machine'

def read_input
  File.open('input/day09.txt').readline
end

def process(stream)
  alphabet = Set.new(stream.chars)
  special_characters = ['{', '}', '<', '>', '!']
  normal_characters = alphabet - special_characters

  group_level = 0
  score = 0
  garbage = 0

  state_machine = StateMachine.new
  # States:
  # S   initial state
  # S!  initial state (cancel next)
  # Gr  parsing group
  # Gr! parsing group (cancel next)
  # Ga  parsing garbage
  # Ga! parsing garbage (cancel next)

  # Rules for state S
  state_machine.add_rule('S', '{', 'Gr', -> { group_level += 1; score += group_level })
  state_machine.add_rule('S', '}', 'S',  -> { group_level -= 1 })
  state_machine.add_rule('S', '<', 'Ga')
  state_machine.add_rule('S', '>', 'S')
  state_machine.add_rule('S', '!', 'S!')
  normal_characters.each { |char| state_machine.add_rule('S', char, 'S') }

  # Rules for state S!
  alphabet.each { |char| state_machine.add_rule('S!', char, 'S') }

  # Rules for state Gr
  state_machine.add_rule('Gr', '{', 'Gr', -> { group_level += 1; score += group_level })
  state_machine.add_rule('Gr', '}', 'Gr', -> { group_level -= 1 })
  state_machine.add_rule('Gr', '<', 'Ga')
  state_machine.add_rule('Gr', '>', 'Gr')
  state_machine.add_rule('Gr', '!', 'Gr!')
  normal_characters.each { |char| state_machine.add_rule('Gr', char, 'Gr') }

  # Rules for state Gr!
  alphabet.each { |char| state_machine.add_rule('Gr!', char, 'Gr')}

  # Rules for state Ga
  state_machine.add_rule('Ga', '{', 'Ga', -> { garbage += 1 }) # group inside garbage is ignored
  state_machine.add_rule('Ga', '}', 'Ga', -> { garbage += 1 })
  state_machine.add_rule('Ga', '<', 'Ga', -> { garbage += 1 }) # another garbage inside garbage is ignored
  state_machine.add_rule('Ga', '>', 'Gr') # return to group since no sub-garbages are allowed
  state_machine.add_rule('Ga', '!', 'Ga!')
  normal_characters.each { |char| state_machine.add_rule('Ga', char, 'Ga', -> { garbage += 1 }) }

  # Rules for state Ga!
  alphabet.each { |char| state_machine.add_rule('Ga!', char, 'Ga')}

  state_machine.initial_state = 'S'
  stream.each_char { |char| state_machine.read(char) }
  [score, garbage]
end

score, garbage = process(read_input)

puts 'Day 9'
puts " - What is the total score for all groups? #{score}"
puts " - How many non-canceled characters are within the garbage? #{garbage}"