require_relative 'board.rb'
require_relative 'player.rb'
require_relative 'text_module.rb'
require 'fileutils'
require 'yaml'

class Game
  include GameText
  def initialize(player1 = '', player2 = '')
    @board = Board.new
    @player1 = Player.new(player1, 'white')
    @player2 = Player.new(player2, 'black')
    @last_color = 'black'
  end

  def play_or_load
    print "\n" + GameText.options

    response = gets.chomp.downcase

    until response == 'new' || response == 'load'
      print '                      try again         -> input  '
      response = gets.chomp.downcase
    end

    new_game if response == 'new'
    load_game if response == 'load'
  end

  def play_chess
    @board.display_board
    loop do
      if @last_color == 'black'
        turn(@player1)

        if @board.checkmate(@player2.color)
          puts "\n" + "    checkmate! #{@player1.name} has won!"
          break
        end

        puts "\n" + "    #{@player2.name} is in check" if @board.in_check(@player2.color)
        @last_color = 'white'

      elsif @last_color == 'white'
        turn(@player2)

        if @board.checkmate(@player1.color)
          puts "\n" + "    checkmate! #{@player2.name} has won!"
          break
        end
  
        puts "\n" + "    #{@player1.name} is in check" if @board.in_check(@player1.color)
        @last_color = 'black'
      end 
    end
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

  def turn(player)

    move = player.move

    if move == 'save'
      save_game
    end

    if move.length == 2
      if @board.get_moves_to_show(move) == false
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
    @board.display_board
  end

  def save_game
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
    if Dir.exist?('saved_games')
      games = Dir.entries('saved_games')

      puts "\n"

      games.each_with_index do |game, index|
        puts "    |#{index}| #{game}" if game.length > 2
      end

      print "\n" + '    please input the number of the game you would like to resume: '
      game_num = gets.chomp.to_i

      FileUtils.cd('saved_games')
      game = YAML.load(File.read(games[game_num]))
      game.play_chess
    else
      puts "\n" + "    no saved games, let's start a new one!"
      new_game
    end
  end
end
