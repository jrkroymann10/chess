require 'colorize'

class Pawn
  attr_accessor :display
  def initialize(color)
    if color == 'black'
     @display = "\u2659".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265f".encode('utf-8')
    end
  end

  def to_str
    @display
  end
end

class Rook
  attr_accessor :display
  def initialize(color)
    if color == 'black'
     @display = "\u2656".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265c".encode('utf-8')
    end
  end

  def to_str
    print @display
  end
end

class Knight
  attr_accessor :display
  def initialize(color)
    if color == 'black'
     @display = "\u2658".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265e".encode('utf-8')
    end
  end

  def to_str
    print @display
  end
end

class Bishop
  attr_accessor :display
  def initialize(color)
    if color == 'black'
     @display = "\u2657".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265d".encode('utf-8')
    end
  end

  def to_str
    print @display
  end
end

class Queen
  attr_accessor :display
  def initialize(color)
    if color == 'black'
     @display = "\u2655".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265b".encode('utf-8')
    end
  end

  def to_str
    print @display
  end
end

class King 
  attr_accessor :display
  def initialize(color)
    if color == 'black'
      @display = "\u2654".encode('utf-8').colorize(:black)
    elsif color == 'white'
      @display = "\u265a".encode('utf-8')
    end
  end

  def to_str
    print @display
  end
end