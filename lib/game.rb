require_relative 'board.rb'
require_relative 'player.rb'

class Game
  def initialize(player1, player2)
    @board = Board.new
    @player1 = Player.new(player1, 'white')
    @player2 = Player.new(player2, 'black')
  end

  def new_game
    @board.display_board
    turn(@player1)

    turn(@player2)
  end

  def turn(player)
    move = player.move

    if move.length == 2
      moves = @board.get_moves_to_show(move)
      @board.show_moves(moves)
      turn(player)
    elsif move.length == 5
      if @board.move_piece(move, player.color) == false
        puts "\n" + 'illegal move warning'
        turn(player)
      end
    end
  end
end

x = Game.new('joe', 'tom')
x.new_game