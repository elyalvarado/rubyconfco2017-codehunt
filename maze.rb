#!/usr/bin/env ruby

# Recursive-backtracking ASCII maze solver 
# made to solve the code hunt by GAP for RubyConfCo 2017
# With a lot of code from: https://defuse.ca/blog/ruby-maze-solver.html

def main
  print_usage unless ARGV[0] && ARGV[1] && ARGV[2] && ARGV[3] && ARGV[4]
  print_usage if ARGV[5] && ARGV[0] != '--play-search'
  shift_args = 0
  shift_args += 1 if ARGV[5]

  begin
    maze = File.open(ARGV[0+shift_args], 'r') { |f| f.read }
    hound_position = [ARGV[1+shift_args], ARGV[2+shift_args]]
    prey_position = [ARGV[3+shift_args], ARGV[4+shift_args]]
  rescue
    puts "Cannot read file."
    print_usage
  end

  solver = MazeSolver.new(maze, hound: hound_position, prey: prey_position) 
  solver.solve(play_search: shift_args > 0)
  puts solver.path.inspect
end

def print_usage
  puts "USAGE: ruby maze.rb [--play-search] <mazefile> <houndX> <houndY> <preyX> <preyY>"
  exit
end

# A recursive backtracking maze solver.
class MazeSolver
  attr_reader :maze, :track, :path

  HOUND_CHAR = 'X'
  TRACK_MARKER = 'o'
  PREY_CHAR = 'E'
  SPACE_CHAR = 'F'
  WALL_CHAR = 'W'

  DELTA_ROW = 0
  DELTA_COL = 1

  # Movement directions are specified internally by a 'delta', which is an
  # array where [0] is the change in row and [1] is the change in column.
  # The player is only allowed to move up, down, left, and right.
  DIRECTIONS = [ [0, -1], [0, 1], [1, 0], [-1, 0] ]

  def initialize(maze, hound:, prey:)
    parse_maze(maze)
    place_hound(hound)
    place_prey(prey)
  end

  # Split the maze string into an array of arrays of characters
  def parse_maze maze
    # First, split it in lines and remove the first and last lines that are empty
    @maze = maze.split("\n")
    while @maze[0].empty? do @maze.shift; end
    while @maze.last.empty? do @maze.pop; end

    @maze = @maze.map do |row|
      # Remove the first 5 characters from the line
      row.slice!(0,5)
      a = row.split("\t")
      a.map { |r| r.empty? ? WALL_CHAR : r }
    end
  end

  # placeHound in the maze
  def place_hound hound
    @player_row = hound[1].to_i
    @player_col = hound[0].to_i
    maze[@player_row][@player_col] = HOUND_CHAR
  end

  def place_prey prey
    maze[prey[1].to_i][prey[0].to_i] = PREY_CHAR
  end

  # Solve the maze. Returns true if it has been solved, false if it cannot be solved.
  def solve(play_search: false)
    @track ||= []
    @path ||= []
    possible_movements.each do |delta|
      move_by delta
      if play_search # Nice to see
        system('clear'); puts self.to_s; sleep 0.1
      end
      break if adjacent_to_finish?
      break if solve(play_search: play_search)
      undo_move_by delta
    end
    adjacent_to_finish?
  end

  # Return an array of valid movement deltas (to SPACE_CHARs) from the current position
  def possible_movements
    deltas = []
    DIRECTIONS.each do |delta|
      deltas.push(delta) if can_move_by? delta
    end
    deltas
  end

  def move_by(delta)
    raise "Invalid movement" unless can_move_by? delta
    @maze[@player_row][@player_col] = TRACK_MARKER
    @maze[@player_row += delta[DELTA_ROW]][@player_col += delta[DELTA_COL]] = HOUND_CHAR
    @track << [@player_col,@player_row] # Add the coordinates to the track stack
    @path << [@player_col,@player_row] # Add the coordinates to the solution path
  end

  def undo_move_by(delta)
    @path.pop # Remove the last coordinates from the path stack
    reverse = delta.map { |x| -x }
    @maze[@player_row][@player_col] = SPACE_CHAR
    @maze[@player_row += reverse[DELTA_ROW]][@player_col += reverse[DELTA_COL]] = HOUND_CHAR
  end

  def adjacent_to_finish?
    DIRECTIONS.each do |delta|
      finish_row = @player_row + delta[DELTA_ROW]
      finish_col = @player_col + delta[DELTA_COL]
      next if finish_row < 0 || finish_col < 0 # Don't check over borders
      return true if @maze[finish_row]&.[](finish_col) == PREY_CHAR
    end
    return false
  end

  def can_move_by?(delta)
    new_row = @player_row + delta[DELTA_ROW]
    new_col = @player_col + delta[DELTA_COL]
    return false if new_row < 0 || new_col < 0 # Don't go over maze borders
    return false if @track.include?([new_col,new_row]) # Don't go to already visited spaces
    return false if count_adjacent_visited_for(delta) > 0 # Don't go to spaces already checked for prey

    @maze[new_row]&.[](new_col) == SPACE_CHAR # Finally validate the space is empty
  end

  def count_adjacent_visited_for(delta)
    new_row = @player_row + delta[DELTA_ROW]
    new_col = @player_col + delta[DELTA_COL]
    DIRECTIONS.inject(0) do |count,d|
      adjacent_row = new_row + d[DELTA_ROW]
      adjacent_col = new_col + d[DELTA_COL]
      return count if adjacent_row < 0 || adjacent_col < 0 # Don't count over borders
      count += 1 if @maze[adjacent_row]&.[](adjacent_col) == TRACK_MARKER
      count
    end
  end

  def to_s
    maze_string = @maze.map {|row| row.join("") }.join("\n")
    maze_string.gsub!(HOUND_CHAR,"🐕 ")
    maze_string.gsub!(TRACK_MARKER,"💠 ")
    maze_string.gsub!(PREY_CHAR,"🦆 ")
    maze_string.gsub!(SPACE_CHAR,"⬛ ")
    maze_string.gsub!(WALL_CHAR,"⬜ ")
    maze_string end

end

main
