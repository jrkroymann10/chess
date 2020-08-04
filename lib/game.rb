require_relative 'board.rb'
require_relative 'player.rb'
require_relative 'text_module.rb'

class Game
  include GameText
  def initialize(player1 = '', player2 = '')
    @board = Board.new
    @player1 = Player.new(player1, 'white')
    @player2 = Player.new(player2, 'black')
  end

  def play_or_save
    print "\n" + GameText.save

    response = gets.chomp.downcase

    until response == 'new' || response == 'load'
      print '                      try again         -> input  '
      response = gets.chomp.downcase
    end

    new_game if response == 'new'
  end

  private

  def new_game
    game_intro
    play_chess
  end

  def game_intro
    print "\n" + GameText.introduction

    gets.chomp

    print "\n" + '    input your name, player 1: '
    p1_name = gets.chomp.downcase

    print "\n" + '    input your name, player 2: '
    p2_name = gets.chomp.downcase

    @player1.name = p1_name
    @player2.name = p2_name

    @board.display_board
  end
  
  def play_chess
    loop do
      turn(@player1)

      if @board.checkmate(@player2.color)
        puts "\n" + "    checkmate! #{@player1.name} has won!"
        break
      end

      puts "\n" + "    #{@player2.name} is in check" if @board.in_check(@player2.color)

      turn(@player2)

      if @board.checkmate(@player1.color)
        puts "\n" + "    checkmate! #{@player2.name} has won!"
        break
      end
    end

    puts "\n" + "    #{@player1.name} is in check" if @board.in_check(@player1.color)
  end

  def turn(player)
    move = player.move

    if move == 'save'
      save_game
    end

    if move.length == 2
      if board.get_moves_to_show(move) == false
        puts "\n" + '    illegal move warning'
      else
      @board.get_moves_to_show(move)
      turn(player)
      end
    elsif move.length == 5
      if @board.move_piece(move, player.color) == false
        puts "\n" + '    illegal move warning'
        turn(player)
      end
    end
  end

  def save_game
    require 'fileutils'
    require 'yaml'

    directory = 'saved_games'

    FileUtils.mkdir(directory) unless Dir.exist?(directory)

    yaml = YAML.dump(self)
    file = File.new("#{@player1.name}_vs_#{@player2.name}.txt", 'w+')
    file.puts(yaml)

    FileUtils.mv "#{@player1.name}_vs_#{@player2.name}.txt", directory

    file.close
    exit

    
  end

  def load_game

  end
end
