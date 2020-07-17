require 'colorize'
require_relative 'pieces.rb'
require 'pry'

class BoardSquare
  attr_accessor :background, :base
  def initialize(back_color, guest = ' ', base = false)
    @background = back_color
    @guest = guest
    @base = base
  end

  def to_str
    if @guest == ' '
      print " #{@guest} ".colorize(:background => :"#{@background}")
    else
      print " #{@guest.display} ".colorize(:background => :"#{@background}")
    end
  end
end

class Board
  attr_accessor :display
  def initialize
    @display = build_board
  end

  def build_board
    board = [[], [], [], [], [], [], [], []]
    board1 = build_first_row(board)
    board2 = build_white_pawns(board1, 1)
    board3 = build_middle(board2)
    board4 = build_black_pawns(board3, 6)
    build_last_row(board4)
  end

  def display_board
    (0..7).each do |row|
      print "\n"
      (0..7).each do |col|
        @display[row][col].to_str
      end
    end
    puts "\n" + "\n"
  end

  private 

  def build_first_row(board)
    (0..7).each do |col|
      if col.zero?
        board[0][col] = BoardSquare.new('cyan', Rook.new('white'))
      elsif col == 7
        board[0][col] = BoardSquare.new('magenta', Rook.new('white'))
      elsif col == 1
        board[0][col] = BoardSquare.new('magenta', Knight.new('white'))
      elsif col == 6
        board[0][col] = BoardSquare.new('cyan', Knight.new('white'))
      elsif col == 2
        board[0][col] = BoardSquare.new('cyan', Bishop.new('white'))
      elsif col == 5
        board[0][col] = BoardSquare.new('magenta', Bishop.new('white'))
      elsif col == 3
        board[0][col] = BoardSquare.new('magenta', Queen.new('white'))
      elsif col == 4
        board[0][col] = BoardSquare.new('cyan', King.new('white'))
      end
    end
    board
  end

  def build_white_pawns(board, row)
    (0..7).each do |col|
      if col.odd?
        board[row][col] = BoardSquare.new('cyan', Pawn.new('white'))
      elsif col.even?
        board[row][col] = BoardSquare.new('magenta', Pawn.new('white'))
      end
    end
    board
  end

  def build_middle(board)
    (2..5).each do |row|
      (0..7).each do |col|
        if row.even? && col.even? || row.odd? && col.odd?
          board[row][col] = BoardSquare.new('cyan')
        elsif row.even? && col.odd? || row.odd? && col.even?
          board[row][col] = BoardSquare.new('magenta')
        end
      end
    end
    board
  end

  def build_black_pawns(board, row)
    (0..7).each do |col|
      if col.odd?
        board[row][col] = BoardSquare.new('magenta', Pawn.new('black'))
      elsif col.even?
        board[row][col] = BoardSquare.new('cyan', Pawn.new('black'))
      end
    end
    board
  end

  def build_last_row(board)
    (0..7).each do |col|
      if col.zero?
        board[7][col] = BoardSquare.new('magenta', Rook.new('black'))
      elsif col == 7
        board[7][col] = BoardSquare.new('cyan', Rook.new('black'))
      elsif col == 1
        board[7][col] = BoardSquare.new('cyan', Knight.new('black'))
      elsif col == 6
        board[7][col] = BoardSquare.new('magenta', Knight.new('black'))
      elsif col == 2
        board[7][col] = BoardSquare.new('magenta', Bishop.new('black'))
      elsif col == 5
        board[7][col] = BoardSquare.new('cyan', Bishop.new('black'))
      elsif col == 3
        board[7][col] = BoardSquare.new('cyan', King.new('black'))
      elsif col == 4
        board[7][col] = BoardSquare.new('magenta', Queen.new('black'))
      end
    end
    board
  end
end

x = Board.new
x.display_board
