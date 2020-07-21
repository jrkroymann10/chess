require 'colorize'
require_relative 'pieces.rb'
require 'pry'

# /lib/board

class BoardSquare
  attr_accessor :background, :base, :guest
  def initialize(back_color, guest = ' ', row = nil)
    @background = back_color
    @guest = guest
    @row = row
  end

  def to_str
    if !@row.nil? && @guest != ' '
      print " #{@row} ".colorize(:white) + " #{@guest.display} ".colorize(:background => :"#{@background}")
    elsif !@row.nil? && @guest == ' '
      print " #{@row} ".colorize(:white) + " #{@guest} ".colorize(:background => :"#{@background}")
    elsif @guest != ' '
      print " #{@guest.display} ".colorize(:background => :"#{@background}")
    elsif @guest.length == 1
      print " #{@guest} ".colorize(:background => :"#{@background}")
    end
  end
end

class Board
  @@horizontal_key = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7
  }
  attr_accessor :display, :horizontal_key
  def initialize
    @display = build_board.reverse
  end

  def build_board
    board = [[], [], [], [], [], [], [], [], []]
    board1 = build_first_row(board)
    board2 = build_white_pawns(board1, 2)
    board3 = build_middle(board2)
    board4 = build_black_pawns(board3, 7)
    build_last_two_rows(board4)
  end

  def display_board
    (0..8).each do |row|
      print "\n"
      (0..7).each do |col|
        @display[row][col].to_str
      end
    end
    puts "\n" + "\n"
  end

  def move_piece(move) # example move = (11:13), move piece at (1, 1) to square at (1, 3)
    mv_start = move[0..1].split('')
    mv_end = move[3..4].split('')
    
    start_row = 8 - mv_start[1].to_i
    start_col = @@horizontal_key[mv_start[0]]
    start_location = [start_row, start_col]
    end_row = 8 - mv_end[1].to_i
    end_col = @@horizontal_key[mv_end[0]]


    temp = @display[start_row][start_col].guest

    moves = filter_pawn(start_location, temp, temp.poss_moves(start_location))
    # binding.pry
    show_moves(moves)
    
    # @display[end_row][end_col].guest = temp
    # @display[start_row][start_col].guest = ' '
  end

  def show_moves(moves)
    moves.each do |move|
      for i in 0..7
        for j in 0..7
          if move == [i, j]
              @display[i][j].background = 'black'
          end
        end
      end
    end
  end

  private

  # classes for building the initial board

  def build_first_row(board)
    (0..7).each do |col|
      if col.zero?
        board[1][col] = BoardSquare.new('cyan', Rook.new('white'), 1)
      elsif col == 7
        board[1][col] = BoardSquare.new('magenta', Rook.new('white'))
      elsif col == 1
        board[1][col] = BoardSquare.new('magenta', Knight.new('white'))
      elsif col == 6
        board[1][col] = BoardSquare.new('cyan', Knight.new('white'))
      elsif col == 2
        board[1][col] = BoardSquare.new('cyan', Bishop.new('white'))
      elsif col == 5
        board[1][col] = BoardSquare.new('magenta', Bishop.new('white'))
      elsif col == 3
        board[1][col] = BoardSquare.new('magenta', Queen.new('white'))
      elsif col == 4
        board[1][col] = BoardSquare.new('cyan', King.new('white'))
      end
    end
    board
  end

  def build_white_pawns(board, row)
    (0..7).each do |col|
      if col.zero?
        board[row][col] = BoardSquare.new('magenta', Pawn.new('white'), 2)
      elsif col.odd?
        board[row][col] = BoardSquare.new('cyan', Pawn.new('white'))
      elsif col.even?
        board[row][col] = BoardSquare.new('magenta', Pawn.new('white'))
      end
    end
    board
  end

  def build_middle(board)
    (3..6).each do |row|
      (0..7).each do |col|
        if col.zero?
          if row.even? && col.even? || row.odd? && col.odd?
            board[row][col] = BoardSquare.new('magenta', ' ', row)
            # binding.pry
          elsif row.even? && col.odd? || row.odd? && col.even?
            board[row][col] = BoardSquare.new('cyan', ' ', row)
          end
        elsif row.even? && col.even? || row.odd? && col.odd?
          board[row][col] = BoardSquare.new('magenta')
        elsif row.even? && col.odd? || row.odd? && col.even?
          board[row][col] = BoardSquare.new('cyan')
        end
      end
    end
    board
  end

  def build_black_pawns(board, row)
    (0..7).each do |col|
      if col.zero?
        board[row][col] = BoardSquare.new('cyan', Pawn.new('black'), 7)
      elsif col.odd?
        board[row][col] = BoardSquare.new('magenta', Pawn.new('black'))
      elsif col.even?
        board[row][col] = BoardSquare.new('cyan', Pawn.new('black'))
      end
    end
    board
  end

  def build_last_two_rows(board)
    (0..7).each do |col|
      if col.zero?
        board[8][col] = BoardSquare.new('magenta', Rook.new('black'), 8)
      elsif col == 7
        board[8][col] = BoardSquare.new('cyan', Rook.new('black'))
      elsif col == 1
        board[8][col] = BoardSquare.new('cyan', Knight.new('black'))
      elsif col == 6
        board[8][col] = BoardSquare.new('magenta', Knight.new('black'))
      elsif col == 2
        board[8][col] = BoardSquare.new('magenta', Bishop.new('black'))
      elsif col == 5
        board[8][col] = BoardSquare.new('cyan', Bishop.new('black'))
      elsif col == 3
        board[8][col] = BoardSquare.new('cyan', King.new('black'))
      elsif col == 4
        board[8][col] = BoardSquare.new('magenta', Queen.new('black'))
      end
    end

    board[0][0] = BoardSquare.new('', '    a')
    letters = ['b','c','d','e','f','g','h']
    letters.each_with_index do |letter, index|
      board[0][index + 1] = BoardSquare.new('', letter)
    end
    board
  end

  public

  # classes for filtering possible moves
    
  def filter()

  end

  def filter_pawn(location, guest, poss_moves)
    moves = []

    # black pawns
    if guest.display == "\u2659".encode('utf-8').colorize(:black)
      if @display[location[0] + 1][location[1] - 1].guest != ' ' && @display[location[0] + 1][location[1] + 1].guest != ' '
        moves << poss_moves[-1] 
        moves << poss_moves[-2]
      elsif @display[location[0] + 1][location[1] + 1].guest != ' '
        moves << poss_moves[-1]
      elsif @display[location[0] + 1][location[1] - 1].guest != ' '
        moves << poss_moves[-2]
      end

      if location[0] == 1 && @display[location[0] + 2][location[1]].guest == ' ' && @display[location[0] + 1][location[1]].guest == ' '
        moves << poss_moves[1]
      end

      if @display[location[0] + 1][location[1]].guest == ' '
        moves << poss_moves[0]
      end
    end

    # white pawns
    if guest.display == "\u265f".encode('utf-8')
      if @display[location[0] - 1][location[1] - 1].guest != ' ' && @display[location[0] - 1][location[1] + 1].guest != ' '
        moves << poss_moves[-1]
        moves << poss_moves[-2]
      elsif @display[location[0] - 1][location[1] + 1].guest != ' '
        moves << poss_moves[-1]
      elsif @display[location[0] - 1][location[1] - 1].guest != ' '
        moves << poss_moves[-2]
      end

      if location[0] == 6 && @display[location[0] - 2][location[1]].guest == ' ' && @display[location[0] - 1][location[1]].guest == ' '
        moves << poss_moves[1]
      end

      if @display[location[0] - 1][location[1]].guest == ' '
        moves << poss_moves[0]
      end
    end
    moves
  end

  def filter_rook

  end
    
  def filter_queen(poss_moves)

  end

  def filter_king(poss_moves)

  end
end

x = Board.new
x.display_board
# p x.display[1]
x.move_piece('b2:b3')
x.display_board
