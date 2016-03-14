#!/usr/bin/env ruby

require 'pp'
require 'set'

class State
  attr_reader :cell_size
  attr_accessor :particles, :grid

  def initialize(time, grid_size, cell_size, particle_number, particles)
    @time = time
    @grid_size = grid_size
    @cell_size = cell_size
    @grid = Hash.new
    @particle_number = particle_number
    @particles = particles
  end  
end

class Particle
  attr_reader :id, :color, :radius
  attr_accessor :x, :y

  @@ids = 0

  def initialize(radius, color)
      @@ids += 1
      @id = @@ids
      @radius = radius
      @color = color
      @x = nil
      @y = nil
  end

  def to_s()
    "id: #{@id}, radius: #{@radius}, color: #{@color}, x: #{@x}, y: #{@y}"
  end
end

def parse_input(static_filename, dynamic_filename)
  time = nil
  grid_size = nil
  particle_number = nil
  particles = []

  File.open(static_filename).each_with_index do |line, index|
    particle_number = line.to_i if index == 0
    grid_size = line.to_i if index == 1
    particles.push(Particle.new(line.split(" ").first.to_f, line.split(" ").last.to_i)) if index > 1
  end

  File.open(dynamic_filename).each_with_index do |line, index|
    if index == 0
      time = line.to_i
    else
      particles[index - 1].x = line.split(" ").first.to_f
      particles[index - 1].y = line.split(" ").last.to_f
    end
  end

  return State.new(time, grid_size, 1, particle_number, particles) # Change this to return array of states, one for each time
end

def align_grid(state)

  state.particles.each do |particle|
    x = particle.x
    y = particle.y
    radius = particle.radius

    state.grid = add_particle(state.grid, state.cell_size, x, y, particle)

    state.grid = add_particle(state.grid, state.cell_size, x - radius, y, particle)
    state.grid = add_particle(state.grid, state.cell_size, x, y - radius, particle)
    state.grid = add_particle(state.grid, state.cell_size, x + radius, y, particle)
    state.grid = add_particle(state.grid, state.cell_size, x, y + radius, particle)

    state.grid = add_particle(state.grid, state.cell_size, x + (0.5 * radius), y + (0.5 * radius), particle)
    state.grid = add_particle(state.grid, state.cell_size, x - (0.5 * radius), y - (0.5 * radius), particle)
    state.grid = add_particle(state.grid, state.cell_size, x - (0.5 * radius), y + (0.5 * radius), particle)
    state.grid = add_particle(state.grid, state.cell_size, x + (0.5 * radius), y - (0.5 * radius), particle)
  end

  return state
end

def add_particle(grid, cell_size, x, y, particle)
  grid[[grid_position(x, cell_size), grid_position(y, cell_size)]] = Set.new if grid[[grid_position(x, cell_size), grid_position(y, cell_size)]] == nil
  grid[[grid_position(x, cell_size), grid_position(y, cell_size)]].add(particle)
  return grid
end

def grid_position(pos, cell_size)
  return (pos/cell_size).floor
end

state = parse_input("Static100.txt", "Dynamic100.txt")
pp align_grid(state).grid