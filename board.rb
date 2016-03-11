require_relative "tile"
require 'byebug'
class Board
  def self.empty_grid
    Array.new(9) { Array.new(9) }
  end

  # def self.from_file(filename)
  #   rows = File.readlines(filename).map(&:chomp)
  #   tiles = rows.map do |row|
  #     nums = row.split("").map { |char| Integer(char) }
  #     nums.map { |num| Tile.new(num) }
  #   end
  #
  #   self.new(tiles)
  # end
  attr_reader :grid

  def initialize(grid = self.class.empty_grid)
    @grid = grid

    populate_bombs
    populate_safe
  end

  def populate_bombs
    grid[0][1] = Tile.new('b')
    num_bombs = size / 10 + 1
    (0...num_bombs).each do |_|
      row, col = 0, 0
      valid = false
      until valid
        row, col = rand(grid.size), rand(grid[0].size)
        valid = valid_bomb?(row, col)
      end

      grid[row][col] = Tile.new('b')
    end
  end

  def populate_safe
    grid.size.times do |i|
      grid[0].size.times do |j|
        next unless grid[i][j].nil?

        grid[i][j] = Tile.new(surrounding_bombs(i, j))
      end
    end
  end

  def surrounding_bombs(row, col)
    count = 0

    ((row - 1)..(row + 1)).each do |i|
      ((col - 1)..(col + 1)).each do |j|
        next if i > 8 || j > 8 || i < 0 || j < 0 || grid[i][j].nil?

        count += 1 if grid[i][j].value == 'b'
      end
    end

    count
  end

  def valid_bomb?(row, col)
    grid[row][col].nil?
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, tile)
    x, y = pos
    grid[x][y] = tile
    # tile.value = value
  end

  def render
    puts "  #{(0..8).to_a.join(" ")}"
    grid.each_with_index do |row, i|
      puts "#{i} #{row.map{ |tile| tile.to_s }.join(" ")}"
    end
  end

  def rows
    grid
  end

  def size
    grid.size * grid[0].size
  end

  def solved?
    grid.flatten.all? { |tile| tile.revealed || (tile.value == 'b') }
  end

  def lost?(row, col)
    grid[row][col].value == 'b'
  end

  # private
  # attr_reader :grid
end
