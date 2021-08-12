# --- Advent of Code 2017 ---
#
# The night before Christmas, one of Santa's Elves calls you in a panic. "The printer's broken! We can't print the
# Naughty or Nice List!" By the time you make it to sub-basement 17, there are only a few minutes until midnight. "We
# have a big problem," she says; "there must be almost fifty bugs in this system, but nothing else can print The List.
# Stand in this square, quick! There's no time to explain; if you can convince them to pay you in stars, you'll be able
# to--" She pulls a lever and the world goes blurry.
#
# When your eyes can focus again, everything seems a lot more pixelated than before. She must have sent you inside the
# computer! You check the system clock: 25 milliseconds until midnight. With that much time, you should be able to
# collect all fifty stars by December 25th.
#
# Collect stars by solving puzzles. Two puzzles will be made available on each day millisecond in the Advent calendar;
# the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

require_relative 'day01'
require_relative 'day02'
require_relative 'day03'
require_relative 'day04'
require_relative 'day05'

puts 'Day 1'
print '-- ', Captcha.solution_1, "\n"
print '-- ', Captcha.solution_2, "\n"

puts 'Day 2'
print '-- ', Checksum.solution_1, "\n"
print '-- ', Checksum.solution_2, "\n"

puts 'Day 3'
print '-- ', SpiralMemory.solution_1, "\n"
print '-- ', SpiralMemory.solution_2, "\n"

puts 'Day 4'
print '-- ', Passphrases.solution_1, "\n"
print '-- ', Passphrases.solution_2, "\n"

puts 'Day 5'
puts "-- #{TwistyTrampolines.solution_1}"
puts "-- #{TwistyTrampolines.solution_2}"