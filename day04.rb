# --- Day 4: High-Entropy Passphrases ---
#
# A new system policy has been put in place that requires all accounts to use a passphrase instead of simply a password.
# A passphrase consists of a series of words (lowercase letters) separated by spaces.
#
# To ensure security, a valid passphrase must contain no duplicate words.
#
# For example:
# aa bb cc dd ee is valid.
# aa bb cc dd aa is not valid - the word aa appears more than once.
# aa bb cc dd aaa is valid - aa and aaa count as different words.
#
# The system's full passphrase list is available as your puzzle input. How many passphrases are valid?
#
# --- Part Two ---
#
# For added security, yet another system policy has been put in place. Now, a valid passphrase must contain no two words
# that are anagrams of each other - that is, a passphrase is invalid if any word's letters can be rearranged to form any
# other word in the passphrase.
#
# For example:
# abcde fghij is a valid passphrase.
# abcde xyz ecdab is not valid - the letters from the third word can be rearranged to form the first word.
# a ab abc abd abf abj is a valid passphrase, because all letters need to be used when forming another word.
# iiii oiii ooii oooi oooo is valid.
# oiii ioii iioi iiio is not valid - any of these words can be rearranged to form any other word.
#
# Under this new system policy, how many passphrases are valid?

require 'set'


class String

  def anagram?(other)
    eql?(other) ? false : split('').sort.eql?(other.split('').sort)
  end

end


class Passphrase

  attr_accessor :strict

  def initialize(string)
    @words = string.split
    @strict = false
  end

  def valid?
    if strict and @words.any? { |word| @words.any? { |other| word.anagram?(other) } }
      return false
    end
    no_duplicates = @words.to_set
    no_duplicates.length == @words.length
  end

end


def read_passphrases
  File.open('input/day04.txt').readlines.map { |line| Passphrase.new(line) }
end


module Passphrases

  def Passphrases.solution_1
    read_passphrases.select { |passphrase| passphrase.valid? }.length
  end

  def Passphrases.solution_2
    passphrases = read_passphrases
    passphrases.each { |passphrase| passphrase.strict = true }
    passphrases.select { |passphrase| passphrase.valid? }.length
  end

end