#!/usr/bin/env ruby

class Grid
  attr_accessor :particles

  def initialize(grid_size, particle_number, particles)
    @grid_size = grid_size
    @particle_number = particle_number
    @particles = particles
  end  
end

class Particle
  attr_writer :x, :y

  def initialize(radius, color)
      @radius = radius
      @color = color
      @x = nil
      @y = nil
  end

  def to_s
    "radius: #{@radius}, color: #{@color}"
  end
end

def parse_static(filename)
  grid_size = nil
  particle_number = nil
  particles = []

  File.open(filename).each_with_index do |line, index|
    particle_number = Integer(line) if index == 0
    grid_size = Integer(line) if index == 1
    particles.push(Particle.new(line.split(" ").first, line.split(" ").last)) if index > 1
  end

  return Grid.new(grid_size, particle_number, particles)
end

def parse_dynamic(filename, grid)
  i = 0
  time = nil
  particles = Hash.new

  File.open(filename).each_with_index do |line, index|
    if index == 0
      time = Integer(line)
      particles[time] = []
    else
      p = grid.particles[i]
      p.x = Float(line.split(" ").first)
      p.y = Float(line.split(" ").last)
      particles[time].push(p)
      i += 1
    end
  end

  grid.particles = particles
end

grid = parse_static("Static100.txt")
parse_dynamic("Dynamic100.txt", grid)
puts grid.particles