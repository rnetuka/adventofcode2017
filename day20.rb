# --- Day 20: Particle Swarm ---
#
# Suddenly, the GPU contacts you, asking for help. Someone has asked it to simulate too many particles, and it won't be
# able to finish them all in time to render the next frame at this rate.
#
# It transmits to you a buffer (your puzzle input) listing each particle in order (starting with particle 0, then
# particle 1, particle 2, and so on). For each particle, it provides the X, Y, and Z coordinates for the particle's
# position (p), velocity (v), and acceleration (a), each in the format <X,Y,Z>.
#
# Each tick, all particles are updated simultaneously. A particle's properties are updated in the following order:
# Increase the X velocity by the X acceleration.
# Increase the Y velocity by the Y acceleration.
# Increase the Z velocity by the Z acceleration.
# Increase the X position by the X velocity.
# Increase the Y position by the Y velocity.
# Increase the Z position by the Z velocity.
#
# Because of seemingly tenuous rationale involving z-buffering, the GPU would like to know which particle will stay
# closest to position <0,0,0> in the long term. Measure this using the Manhattan distance, which in this situation is
# simply the sum of the absolute values of a particle's X, Y, and Z position.
#
# For example, suppose you are only given two particles, both of which stay entirely on the X-axis (for simplicity).
# Drawing the current states of particles 0 and 1 (in that order) with an adjacent a number line and diagram of current
# X positions (marked in parentheses), the following would take place:
# p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>    -4 -3 -2 -1  0  1  2  3  4
# p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>                         (0)(1)
#
# p=< 4,0,0>, v=< 1,0,0>, a=<-1,0,0>    -4 -3 -2 -1  0  1  2  3  4
# p=< 2,0,0>, v=<-2,0,0>, a=<-2,0,0>                      (1)   (0)
#
# p=< 4,0,0>, v=< 0,0,0>, a=<-1,0,0>    -4 -3 -2 -1  0  1  2  3  4
# p=<-2,0,0>, v=<-4,0,0>, a=<-2,0,0>          (1)               (0)
#
# p=< 3,0,0>, v=<-1,0,0>, a=<-1,0,0>    -4 -3 -2 -1  0  1  2  3  4
# p=<-8,0,0>, v=<-6,0,0>, a=<-2,0,0>                         (0)
#
# At this point, particle 1 will never be closer to <0,0,0> than particle 0, and so, in the long run, particle 0 will
# stay closest.
#
# Which particle will stay closest to position <0,0,0> in the long term?
#
# --- Part Two ---
#
# To simplify the problem further, the GPU would like to remove any particles that collide. Particles collide if their
# positions ever exactly match. Because particles are updated simultaneously, more than two particles can collide at the
# same time and place. Once particles collide, they are removed and cannot collide with anything else after that tick.
#
# For example:
# p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>
# p=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>    -6 -5 -4 -3 -2 -1  0  1  2  3
# p=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>    (0)   (1)   (2)            (3)
# p=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>
#
# p=<-3,0,0>, v=< 3,0,0>, a=< 0,0,0>
# p=<-2,0,0>, v=< 2,0,0>, a=< 0,0,0>    -6 -5 -4 -3 -2 -1  0  1  2  3
# p=<-1,0,0>, v=< 1,0,0>, a=< 0,0,0>             (0)(1)(2)      (3)
# p=< 2,0,0>, v=<-1,0,0>, a=< 0,0,0>
#
# p=< 0,0,0>, v=< 3,0,0>, a=< 0,0,0>
# p=< 0,0,0>, v=< 2,0,0>, a=< 0,0,0>    -6 -5 -4 -3 -2 -1  0  1  2  3
# p=< 0,0,0>, v=< 1,0,0>, a=< 0,0,0>                       X (3)
# p=< 1,0,0>, v=<-1,0,0>, a=< 0,0,0>
#
# ------destroyed by collision------
# ------destroyed by collision------    -6 -5 -4 -3 -2 -1  0  1  2  3
# ------destroyed by collision------                      (3)
# p=< 0,0,0>, v=<-1,0,0>, a=< 0,0,0>
#
# In this example, particles 0, 1, and 2 are simultaneously destroyed at the time and place marked X. On the next tick,
# particle 3 passes through unharmed.
#
# How many particles are left after all collisions are resolved?

class Particle

  attr_writer :x_velocity, :y_velocity, :z_velocity, :x_acceleration, :y_acceleration, :z_acceleration
  attr_accessor :x, :y, :z

  def self.parse(string)
    match = /p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>/.match(string)
    particle = Particle.new
    particle.x = match[1].to_i
    particle.y = match[2].to_i
    particle.z = match[3].to_i
    particle.x_velocity = match[4].to_i
    particle.y_velocity = match[5].to_i
    particle.z_velocity = match[6].to_i
    particle.x_acceleration = match[7].to_i
    particle.y_acceleration = match[8].to_i
    particle.z_acceleration = match[9].to_i
    particle
  end

  def update
    @x_velocity += @x_acceleration
    @y_velocity += @y_acceleration
    @z_velocity += @z_acceleration
    @x += @x_velocity
    @y += @y_velocity
    @z += @z_velocity
  end

  def acceleration
    @x_acceleration.abs + @y_acceleration.abs + @z_acceleration.abs
  end

  def distance
    x.abs + y.abs + z.abs
  end

  def eql?(other)
    x == other.x and y == other.y and z == other.z
  end

  def hash
    [x, y, z].hash
  end

end

def read_particles
  File.open('input/day20.txt').readlines.map { |line| Particle.parse(line) }
end

def solution_1
  particles = read_particles

  # X coordinate of a particle:
  # At time = 0, x = x0 (read from the input)
  # At time = 1, x = x_velocity(t0) (<- read from the input) + x_acceleration
  # At time = 2, x = x_velocity(t1) (<- value from time = 1) + x_acceleration = x_velocity(t0) + 2* x_acceleration
  # At time = 3, x = x_velocity(t2) (<- value from time = 2) + x_acceleration = x_velocity(t0) + 3* x_acceleration
  # ... and so on
  # This means that for every particle:
  # x(t) = x_velocity + t* x_acceleration
  # y(t) = y_velocity + t* y_acceleration
  # z(t) = z_velocity + t* z_acceleration
  #
  # So only the acceleration value (for axis x, y and z) is significant, because it is multiplied by high values of t at
  # some time.
  accelerations = particles.map { |particle| particle.acceleration }

  # select particles with lowest acceleration
  candidates = particles.select { |particle| particle.acceleration == accelerations.min }

  # out of these candidates, select the one with lowest starting distance
  result = candidates.min { |a, b| a.distance <=> b.distance }
  particles.index(result)
end

def solution_2
  particles = read_particles
  100.times do
    positions = {}
    positions.default = 0
    particles.each do |particle|
      particle.update
      positions[particle] += 1
    end
    particles.delete_if { |particle| positions[particle] > 1 }
  end
  particles.length
end

puts 'Day 20'
puts " - Which particle will stay closest to position <0,0,0>? #{solution_1}"
puts " - How many particles are left? #{solution_2}"