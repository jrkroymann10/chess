require 'colorize'

class Pawn
  attr_accessor :display, :id, :color
  def initialize(color, id = 'pawn')
    @id = id
    @color = color
    if color == 'black'
      @display = "\u2659".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265f".encode('utf-8')
    end
  end

  def poss_moves(location)
    moves = []
    if location[0] == 1 && @color == 'black'
      moves = [[location[0] + 1, location[1]], [location[0] + 2, location[1]],
               [location[0] + 1, location[1] - 1], [location[0] + 1, location[1] + 1]]
    elsif location[0] == 6 && @color == 'white'
      moves = [[location[0] - 1, location[1]], [location[0] - 2, location[1]],
               [location[0] - 1, location[1] - 1], [location[0] - 1, location[1] + 1]]
    elsif @color == 'black'
      moves = [[location[0] + 1, location[1]], [location[0] + 1, location[1] - 1], [location[0] + 1, location[1] + 1]]
    elsif @color == 'white'
      moves = [[location[0] - 1, location[1]], [location[0] - 1, location[1] - 1], [location[0] - 1, location[1] + 1]]
    end

    moves.filter { |move| move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7 }
  end

  def to_str
    @display
  end
end

class Rook
  attr_accessor :display, :id, :color
  def initialize(color, id = 'rook')
    @color = color
    @id = id
    if color == 'black'
      @display = "\u2656".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265c".encode('utf-8')
    end
  end

  def poss_moves(location)
    moves = [[], []] # moves[0] = vertical, moves[1] = horizontal
    (0..7).each do |num|
      moves[0] << [location[0], num]
      moves[1] << [num, location[1]]
    end
    moves
  end

  def to_str
    print @display
  end
end

class Knight
  attr_accessor :display, :id, :color
  def initialize(color, id = 'knight')
    @color = color
    @id = id
    if color == 'black'
      @display = "\u2658".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265e".encode('utf-8')
    end
  end

  def poss_moves(location)
    moves = [[location[0] + 2, location[1] + 1], [location[0] + 1, location[1] + 2],
             [location[0] + 2, location[1] - 1], [location[0] + 1, location[1] - 2],
             [location[0] - 2, location[1] + 1], [location[0] - 1, location[1] + 2],
             [location[0] - 2, location[1] - 1], [location[0] - 1, location[1] - 2]]

    moves.filter { |move| move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7 }
  end

  def to_str
    print @display
  end
end

class Bishop
  attr_accessor :display, :id, :color
  def initialize(color, id = 'bishop')
    @id = id
    @color = color
    if color == 'black'
      @display = "\u2657".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265d".encode('utf-8')
    end
  end

  def poss_moves(location)
    moves = [[], [], [], []] # moves[0] = lower-left moves, moves[1] = upper-left moves, moves[2] = upper-right moves, moves[3] = lower-right moves

    (0...location[1]).each do |col|
      moves[0] << [location[0] + location[1] - col, col] if location[0] + location[1] - col <= 7
      moves[1] << [location[0] - location[1] + col, col] if location[0] - location[1] + col >= 0
    end

    ((location[1] + 1)..7).reverse_each do |col|
      moves[2] << [location[0] - col + location[1], col] if location[0] - col + location[1] >= 0
      moves[3] << [location[0] + col - location[1], col] if location[0] + col - location[1] <= 7
    end

    moves 
  end

  def to_str
    print @display
  end
end

class Queen
  attr_accessor :display, :id, :color
  def initialize(color, id = 'queen')
    @id = id
    @color = color
    if color == 'black'
      @display = "\u2655".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265b".encode('utf-8')
    end
  end

  def poss_moves(location)
    moves = [[], [], [], [], [], []]

    (0..7).each do |num|
      moves[0] << [location[0], num]
      moves[1] << [num, location[1]]
    end

    (0...location[1]).each do |col|
      moves[2] << [location[0] + location[1] - col, col] if location[0] + location[1] - col <= 7
      moves[3] << [location[0] - location[1] + col, col] if location[0] - location[1] + col >= 0
    end


    ((location[1] + 1)..7).reverse_each do |col|
      moves[4] << [location[0] - col + location[1], col] if location[0] - col + location[1] >= 0
      moves[5] << [location[0] + col - location[1], col] if location[0] + col - location[1] <= 7
    end
    moves
  end

  def to_str
    print @display
  end
end

class King
  attr_accessor :display, :id, :color
  def initialize(color, id = 'king')
    @id = id
    @color = color
    if color == 'black'
      @display = "\u2654".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265a".encode('utf-8')
    end
  end

  def poss_moves(location)
    moves = [[location[0], location[1] + 1], [location[0], location[1] + -1], [location[0] + 1, location[1]],
             [location[0] + 1, location[1] - 1], [location[0] + 1, location[1] + 1], [location[0] - 1, location[1] + 1],
             [location[0] - 1, location[1] - 1], [location[0] - 1, location[1]]]

    moves.filter { |move| move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7 }
  end

  def to_str
    print @display
  end
end
