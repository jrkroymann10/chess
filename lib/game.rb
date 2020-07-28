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

    loop do
      turn(@player1)

      if @board.checkmate(@player2.color)
        puts "\n" + "checkmate! #{@player1.name} has won!"
        break
      end

      puts "\n" + "#{@player2.name} is in check" if @board.in_check(@player2.color)

      turn(@player2)

      if @board.checkmate(@player1.color)
        puts "\n" + "checkmate! #{@player2.name} has won!"
        break
      end

      puts "\n" + "#{@player1.name} is in check" if @board.in_check(@player1.color)
    end
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