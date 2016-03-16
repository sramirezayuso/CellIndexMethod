#!/usr/bin/env ruby

# Prints the list of particles ids with its corresponding neighbors
module Printer
  def print_to_file(close_particles)
  	Dir.mkdir("out") unless File.exists?("out")
  	time = Time.now.strftime("%d-%m-%Y|%H:%M:%S")
    file = File.open("out/output#{time}.txt", 'w')
    close_particles.each do |particle_id, particle_neighbors|
      file.write("#{particle_id} ")
      particle_neighbors.each { |neighbor_id| file.write("#{neighbor_id} ") }
      file.write("\n")
    end
  end
end