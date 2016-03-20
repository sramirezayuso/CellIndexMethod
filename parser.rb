#!/usr/bin/env ruby

module Parser
  def parse_input(static_filename, dynamic_filename, row_amount)
    time = nil
    grid_size = nil
    particle_number = nil
    particles = []

    File.open(static_filename).each_with_index do |line, index|
      particle_number = line.to_i if index == 0
      grid_size = line.to_i if index == 1
      particles.push(Particle.new(line.split(" ").first.to_f, line.split(" ").last.to_f)) if index > 1
    end

    File.open(dynamic_filename).each_with_index do |line, index|
      if index == 0
        time = line.to_i
      else
        particle_components = line.split(" ")
        particles[index - 1].x = particle_components[0].to_f
        particles[index - 1].y = particle_components[1].to_f
        particles[index - 1].vx = particle_components[2].to_f
        particles[index - 1].vy = particle_components[3].to_f
      end
    end

    return State.new(time, grid_size, grid_size / row_amount.to_f, particle_number, particles) # Change this to return array of states, one for each time
  end
end