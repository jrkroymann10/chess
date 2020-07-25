class Player
  attr_accessor :name, :color
  def initialize(name, color = '')
    @name = name.downcase
    @color = color
  end

  def move
    move = ''

    until move.length == 2 || move.length == 5
      print "\n" + "your move, #{@name}: "
      move = gets.chomp
    end
    move
  end
end

# x = Player.new('joe')
# x.move
