require 'ostruct'

def rule(state, read, write, move, next_state)
  OpenStruct.new(:state => state, :read => read, :write => write, :move => move, :next_state => next_state)
end

class TuringMachine

  def initialize
    @tape = [0]
    @cursor = 0
    @state = 'A'
    @rules = [
      rule('A', 0, 1, :right, 'B'),
      rule('A', 1, 1, :left, 'E'),
      rule('B', 0, 1, :right, 'C'),
      rule('B', 1, 1, :right, 'F'),
      rule('C', 0, 1, :left, 'D'),
      rule('C', 1, 0, :right, 'B'),
      rule('D', 0, 1, :right, 'E'),
      rule('D', 1, 0, :left, 'C'),
      rule('E', 0, 1, :left, 'A'),
      rule('E', 1, 0, :right, 'D'),
      rule('F', 0, 1, :right, 'A'),
      rule('F', 1, 1, :right, 'C')
    ]
  end

  def take_step
    rule = @rules.select { |rule| rule.state == @state and rule.read == @tape[@cursor] }[0]
    @tape[@cursor] = rule.write
    if rule.move == :left
      if @cursor == 0
        @tape.prepend(0)
      else
        @cursor -= 1
      end
    else  # rule.move == :right
      @cursor += 1
      @tape.append(0) if @cursor >= @tape.length
    end
    @state = rule.next_state
  end

  def diagnostic_checksum
    @tape.count(1)
  end

end

def solution
  machine = TuringMachine.new
  12_459_852.times { machine.take_step }
  machine.diagnostic_checksum
end

puts 'Day 25'
puts "What is the diagnostic checksum? #{solution}"