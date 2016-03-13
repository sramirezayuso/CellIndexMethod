#!/usr/bin/env ruby

class Particle
  def initialize(radius, color)
      @radius = radius
      @color = color
      @x = nil
      @y = nil
  end

  def to_s()
    "radius: #{@radius}, color: #{@color}"
  end
end

def parse_static(filename)
  grid_size = 0
  particle_number = 0
  particles = []
  File.open(filename).each_with_index do |line, index|
    particle_number = Integer(line) if index == 0
    grid_size = Integer(line) if index == 1
    particles.push(Particle.new(line.split(" ").first, line.split(" ").last)) if index > 1
  end

  puts grid_size
  puts particle_number
  puts particles
end

def parse_dynamic()
  File.open(filename).each_with_index do |line, index|
  end
end

parse_static("Static100.txt")
