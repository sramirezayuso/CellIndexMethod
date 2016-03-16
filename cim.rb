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
    @grid = {}
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

class Cell
  attr_accessor :i, :j

  def initialize(i, j)
    @i = i
    @j = j
  end

  def eql?(other)
    self.i == other.i && self.j == other.j
  end

  def hash
    i.hash + j.hash
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
  cell = Cell.new(grid_position(x, cell_size), grid_position(y, cell_size))
  grid[cell] = Set.new if grid[cell] == nil
  grid[cell].add(particle)
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

def cell_index_method(state, rc)
  file = File.open("output.txt", 'w')
  close_particles = {}

  state.particles.each do |p|
    close_particles[p.id] = Set.new
  end

  grid = state.grid
  grid.keys.each do |cell|
    evaluate_neighbors(grid, close_particles, cell, cell, rc)
    evaluate_neighbors(grid, close_particles, cell, Cell.new(cell.i, cell.j + 1), rc)
    evaluate_neighbors(grid, close_particles, cell, Cell.new(cell.i + 1, cell.j - 1), rc)
    evaluate_neighbors(grid, close_particles, cell, Cell.new(cell.i + 1, cell.j), rc)
    evaluate_neighbors(grid, close_particles, cell, Cell.new(cell.i + 1, cell.j + 1), rc)
  end

  pp close_particles
end

def evaluate_neighbors(grid, close_particles, cell, other_cell, rc)
  if grid.has_key?(other_cell)
    particles = grid[cell]
    other_particles = grid[other_cell]

    particles.each do |p1|
      other_particles.each do |p2|
        if p1.id != p2.id && are_particles_neighbors(p1, p2, rc)
          close_particles[p1.id].add(p2.id)
        end
      end
    end
  end
end

def are_particles_neighbors(p1, p2, rc)
  Math.hypot(p1.x - p2.x, p1.y - p2.y) - p1.radius - p2.radius <= rc
end


m = ARGV[0].to_i
rc = ARGV[1].to_f
raise ArgumentError, "The amount of cells and particle interaction radius are both required" if m == nil || rc == nil

state = parse_input("Static100.txt", "Dynamic100.txt", m)
rmax = state.particles.max {|a, b| a.radius <=> b.radius}.radius
raise ArgumentError, "Wrong argument value: L/M > rc + 2*rmax" if state.cell_size <= rc + 2 * rmax

align_grid(state)
cell_index_method(state, rc)