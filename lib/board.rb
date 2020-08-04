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
      print "    #{@row} ".colorize(:white) + " #{@guest.display} ".colorize(:background => :"#{@background}")
    elsif !@row.nil? && @guest == ' '
      print "    #{@row} ".colorize(:white) + " #{@guest} ".colorize(:background => :"#{@background}")
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
    puts "\n"
  end

  # example move = (a2:a3), move piece at (6, 0) to square at (5, 0)
  def move_piece(move, color) 
    squares = find_start_and_end(move) # [start, end]

    return false if @display[squares[0][0]][squares[0][1]].guest == ' '

    start_piece = @display[squares[0][0]][squares[0][1]].guest

    return false if start_piece.color != color 

    moves = get_legal_moves(squares[0], start_piece, start_piece.poss_moves(squares[0]))


    if moves.include?(squares[1])

      # castling
      if start_piece.id == 'king' && start_piece.color == 'white' && squares[1] == [7, 1] 
        make_move(squares[0], squares[1], start_piece)
        make_move([7, 0], [7, 2], @display[0][0].guest)
      elsif start_piece.id == 'king' && start_piece.color == 'black' && squares[1] == []
        make_move(squares[0], squares[1], start_piece)
        make_move([0, 0], [0, 2], @display[7][0].guest)

      # pawn -> queen upgrade
      elsif start_piece.id == 'pawn' && start_piece.color == 'white' && squares[1][0].zero?
        make_move(squares[0], squares[1], Queen.new('white'))
      elsif start_piece.id == 'pawn' && start_piece.color == 'black' && squares[1][0] == 7
        make_move(squares[0], squares[1], Queen.new('black'))

      else
        make_move(squares[0], squares[1], start_piece)
      end
    else
      false
    end
  end

  def get_moves_to_show(location)
    loc_array = location.split('')

    square = [8 - loc_array[1].to_i, @@horizontal_key[loc_array[0].downcase]]

    return false if @display[square[0]][square[1]].guest == ' '

    piece = @display[square[0]][square[1]].guest

    moves = get_legal_moves(square, piece, piece.poss_moves(square))

    show_moves(moves)
  end

  def in_check(color)
    king_location = find_king(color)
    moves = []
    (0..7).each do |row|
      (0..7).each do |col|
        if @display[row][col].guest != ' ' && @display[row][col].guest.color != color
          moves += filter([row, col], @display[row][col].guest, @display[row][col].guest.poss_moves([row, col]))
        end
      end
    end

    moves.include?(king_location) ? true : false
  end

  def checkmate(color)
    result = true

    return false unless in_check(color)

    (0..7).each do |row|
      (0..7).each do |col|
        next if @display[row][col].guest == ' ' || @display[row][col].guest.color != color

        start = [row, col]
        piece = @display[row][col].guest

        moves = get_legal_moves(start, piece, piece.poss_moves(start))

        result = false unless moves == []
      end
    end
    result
  end

  private

  def show_moves(moves)
    colors = []
    moves.each do |move|
      (0..7).each do |row|
        (0..7).each do |col|
          if move == [row, col]
            colors.push(@display[row][col].background)
            @display[row][col].background = 'light_white'
          end
        end
      end
    end
    display_board
    reset_background(colors, moves)
  end

  def find_king(color)
    location = []
    (0..7).each do |row|
      (0..7).each do |col|
        if @display[row][col].guest != ' ' && @display[row][col].guest.id == 'king' && @display[row][col].guest.color == color
          location = [row, col]
          break
        end
      end
    end
    location
  end

  # methods for moving a piece on the board

  def find_start_and_end(move)
    mv_start = move[0..1].split('')
    mv_end = move[3..4].split('')

    start_row = 8 - mv_start[1].to_i
    start_col = @@horizontal_key[mv_start[0].downcase]
    start_location = [start_row, start_col]

    end_row = 8 - mv_end[1].to_i
    end_col = @@horizontal_key[mv_end[0].downcase]
    end_location = [end_row, end_col]

    [start_location, end_location]
  end

  def get_legal_moves(start, guest, poss_moves)
    moves = filter(start, guest, poss_moves)
    remove_if_put_in_check(start, guest, moves)
  end

  def make_move(start_location, end_location, piece)
    @display[end_location[0]][end_location[1]].guest = piece
    @display[start_location[0]][start_location[1]].guest = ' '
    display_board
  end

  def undo_move(start_location, end_location, piece, end_guest)
    @display[end_location[0]][end_location[1]].guest = end_guest
    @display[start_location[0]][start_location[1]].guest = piece
  end

  # resets background colors after showing possible moves in different color

  def reset_background(colors, moves)
    moves.each do |move|
      (0..7).each do |row|
        (0..7).each do |col|
          @display[row][col].background = colors.shift if move == [row, col]
        end
      end
    end
  end

  # methods for building the initial board

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
        board[1][col] = BoardSquare.new('magenta', King.new('white'))
      elsif col == 4
        board[1][col] = BoardSquare.new('cyan', Queen.new('white'))
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

    board[0][0] = BoardSquare.new('', '       a')
    letters = ['b','c','d','e','f','g','h']
    letters.each_with_index do |letter, index|
      board[0][index + 1] = BoardSquare.new('', letter)
    end
    board
  end

  # methods for filtering possible moves

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

  def remove_if_put_in_check(start, piece, poss_moves)
    moves = []

    color = piece.color
    find_king(color)

    poss_moves.each do |move|
      end_guest = @display[move[0]][move[1]].guest

      @display[move[0]][move[1]].guest = piece
      @display[start[0]][start[1]].guest = ' '

      moves.push(move) unless in_check(color)

      undo_move(start, move, piece, end_guest)
    end
    moves
  end

  def filter_pawn(location, guest, poss_moves)
    moves = []

    # black pawns
    if guest.display == "\u2659".encode('utf-8').colorize(:black)
      if location[1] < 7 && @display[location[0] + 1][location[1] + 1].guest != ' ' && @display[location[0] + 1][location[1] + 1].guest.color != 'black'
        moves << poss_moves[-1]
      end

      if location[1] > 0 && @display[location[0] + 1][location[1] - 1].guest != ' ' && @display[location[0] + 1][location[1] - 1].guest.color != 'black'
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
      if location[1] < 7 && @display[location[0] - 1][location[1] + 1].guest != ' ' && @display[location[0] - 1][location[1] + 1].guest.color != 'white'
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
    quads = [poss_moves[0].reverse, poss_moves[1].reverse, poss_moves[2].reverse, poss_moves[3].reverse]

    filter_from_start(quads, guest.color)
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

  def filter_queen(location, guest, poss_moves)
    filter_rook(location, guest, poss_moves[0..1]) + filter_bishop(location, guest, poss_moves[2..5])
  end

  def filter_king(location, guest, poss_moves)
    moves = []

    poss_moves.each do |move|
      moves.push(move) if @display[move[0]][move[1]].guest == ' ' || @display[move[0]][move[1]].guest.color != guest.color
    end

    # castling

    if location == [7, 3] && guest.color == 'white'
      moves.push([7, 1]) if @display[7][1].guest == ' ' && @display[7][2].guest == ' ' && @display[7][0].guest.id == 'rook'
    end

    if location == [0, 3] && guest.color == 'black'
      moves.push([0, 1]) if @display[0][1].guest == ' ' && @display[0][2].guest == ' ' && @display[0][0].guest.id == 'rook'
    end

    moves
  end
end
