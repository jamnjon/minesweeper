class Tile
  attr_reader :value, :revealed, :flagged

  def initialize(value)
    @revealed = false
    @flagged = false
    @value = value
  end

  # def value
  #   return "b" if bomb
  #   #Integer but we'll want to convert to string for our return
  #   #Going to involve a recursive method
  #
  # end

  def bomb?
    @bomb
  end

  def to_s
    return "f" if @flagged

    revealed ? value : " "
  end






































end
