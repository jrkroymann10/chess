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
    end_location = [end_row, end_col]

    temp = @display[start_row][start_col].guest

    moves = filter(start_location, temp, temp.poss_moves(start_location))

    show_moves(moves)

    if moves.include?(end_location)
      @display[end_row][end_col].guest = temp
      @display[start_row][start_col].guest = ' '
      display_board
    else
      false
    end
  end

  def show_moves(moves)
    colors = []
    moves.each do |move|
      (0..7).each do |row|
        (0..7).each do |col|
          if move == [row, col]
            colors.push(@display[row][col].background)
            @display[row][col].background = 'light_black'
          end
        end
      end
    end
    display_board
    reset_background(colors, moves)
  end

  def reset_background(colors, moves)
    moves.each do |move|
      (0..7).each do |row|
        (0..7).each do |col|
          @display[row][col].background = colors.shift if move == [row, col]
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

  def filter(location, guest, poss_moves)
    case guest.id

    when 'pawn'
      filter_pawn(location, guest, poss_moves)

    when 'rook'
      filter_rook(location, guest, poss_moves)

    when 'knight'
      filter_knight(location, guest, poss_moves)

    when 'bishop'
      filter_bishop(location, guest, poss_moves)

    when 'queen'
      filter_queen(location, guest, poss_moves)

    when 'king'
      filter_king(location, guest, poss_moves)

    end
  end

  def filter_pawn(location, guest, poss_moves)
    moves = []

    # black pawns
    if guest.display == "\u2659".encode('utf-8').colorize(:black)
      if location[1] < 7 && @display[location[0] + 1][location[1] + 1].guest != ' ' && @display[location[0] + 1][location[1] + 1].guest.color != 'black'
        moves << poss_moves[-1]
      end

      if @display[location[0] + 1][location[1] - 1].guest != ' ' && @display[location[0] + 1][location[1] - 1].guest.colorn != 'black'
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
      if @display[location[0] - 1][location[1] + 1].guest != ' ' && @display[location[0] - 1][location[1] + 1].guest.color != 'white'
        moves << poss_moves[-1]
      end

      if location[1] > 0 && @display[location[0] - 1][location[1] - 1].guest != ' ' && @display[location[0] - 1][location[1] - 1].guest.color != 'white'
        moves << poss_moves[-2]
      end

      if location[0] == 6 && @display[location[0] - 2][location[1]].guest == ' ' && @display[location[0] - 1][location[1]].guest == ' '
        moves << poss_moves[1]
      end

      moves << poss_moves[0] if @display[location[0] - 1][location[1]].guest == ' '
    end
    moves
  end

  def filter_rook(location, guest, poss_moves)

    hor_temp = poss_moves[0].index(location)
    vert_temp = poss_moves[1].index(location)

    left_horizontal = poss_moves[0][0...hor_temp].reverse
    right_horizontal = poss_moves[0][(hor_temp + 1)...poss_moves[0].length]

    top_vertical = poss_moves[1][0...vert_temp].reverse
    bot_vertical = poss_moves[1][(vert_temp + 1)...poss_moves[1].length]

    filter_from_start([left_horizontal, right_horizontal, top_vertical, bot_vertical], guest.color)
  end

  def filter_bishop(_location, guest, poss_moves)
    
  end

  def filter_from_start(quads, col)
    moves = []

    quads.each do |quad|
      for i in 0...quad.length
        if @display[quad[i][0]][quad[i][1]].guest == ' '
          moves.push(quad[i])
        elsif @display[quad[i][0]][quad[i][1]].guest != ' ' && @display[quad[i][0]][quad[i][1]].guest.color != col
          moves.push(quad[i])
          break
        elsif @display[quad[i][0]][quad[i][1]].guest != ' ' && @display[quad[i][0]][quad[i][1]].guest.color == col
          break
        end
      end
    end
    moves
  end

  def filter_knight(_location, guest, poss_moves)
    moves = []

    poss_moves.each do |move|
      moves.push(move) if @display[move[0]][move[1]].guest == ' ' || @display[move[0]][move[1]].guest.color != guest.color
    end
    moves
  end
  
  def filter_queen(poss_moves)

  end

  def filter_king(poss_moves)

  end
end

x = Board.new
x.display_board

x.move_piece('b1:c3')
x.move_piece('c3:d5')
x.move_piece('d5:e7')

# x.move_piece('a2:a4')
# x.move_piece('h7:h5')
# x.move_piece('a1:a3')
# x.move_piece('h8:h6')
# x.move_piece('g2:g3')
# x.move_piece('h6:f6')
# x.move_piece('a3:f3')
# x.move_piece('a7:a5')
# x.move_piece('f3:f5')
