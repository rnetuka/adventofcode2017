class Component

  attr_reader :pin_a, :pin_b

  def initialize(pin_a, pin_b)
    @pin_a = pin_a
    @pin_b = pin_b
    @attached = nil
  end

  def Component.parse(string)
    pins = string.split('/')
    Component.new(pins[0].to_i, pins[1].to_i)
  end

  def pins
    [@pin_a, @pin_b]
  end

  def strength
    @pin_a + @pin_b
  end

end

class Bridge

  attr_accessor :components, :ending_pin

  def initialize
    @components = []
    @ending_pin = 0
  end

  def append(component)
    bridge = Bridge.new
    bridge.components = @components.dup
    bridge.components.append(component)
    bridge.ending_pin = (@ending_pin == component.pin_a ? component.pin_b : component.pin_a)
    bridge
  end

  def strength
    @components.reduce(0) { |strength, component| strength + component.strength }
  end

  def length
    @components.length
  end

end

def read_components
  File.open('input/day24.txt').readlines.map { |string| Component.parse(string) }
end

def make_bridges
  components = read_components
  bridges = []
  root = Bridge.new
  queue = [root]
  until queue.empty?
    bridge = queue.shift
    bridges.append(bridge)
    available = components - bridge.components
    compatible = available.select { |component| component.pins.include?(bridge.ending_pin) }
    compatible.each { |component|
      queue.append(bridge.append(component))
    }
  end
  bridges
end

def solution_1(bridges)
  strongest = bridges.max_by { |bridge| bridge.strength }
  strongest.strength
end

def solution_2(bridges)
  max_length = bridges.map { |bridge| bridge.length }.max
  candidates = bridges.select { |bridge| bridge.length == max_length }
  strongest = candidates.max_by { |bridge| bridge.strength }
  strongest.strength
end

bridges = make_bridges

puts 'Day 24'
puts " - What is the strength of the strongest bridge you can make? #{solution_1(bridges)}"
puts " - What is the strength of the longest bridge you can make? #{solution_2(bridges)}"
