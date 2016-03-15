#!/usr/bin/env ruby

require 'pp'
require 'set'
require './parser.rb'
include Parser

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
  attr_accessor :x, :y, :vx, :vy

  @@ids = 0

  def initialize(radius, color)
      @@ids += 1
      @id = @@ids
      @radius = radius
      @color = color
      @x = nil
      @y = nil
      @vx = nil
      @vy = nil
  end

  def to_s()
    "id: #{@id}, radius: #{@radius}, color: #{@color}, x: #{@x}, y: #{@y}"
  end
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

def distance_between_all_particles(particles)
  particles.each_with_index do |p, index|
    for i in index+1..particles.length-1
      # Decide how the distance should be managed
      distance = Math.hypot(p.x - particles[i].x, p.y - particles[i].y)
    end
  end
end

state = parse_input("Static100.txt", "Dynamic100.txt")
pp align_grid(state).grid
