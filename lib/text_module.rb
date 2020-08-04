module GameText
  @@introduction = "    welcome to human vs. human chess in the terminal! this game
    adheres to the common rules of chess (a quick google search will tell everything
    you need to know). to move a piece, simply type in the location of the piece,
    followed by a colon, and the location you would like to move the piece to.
    for example, if you wanted to move a rook from b1 to a3, one would input b1:a3
    to execute the move. additionally, if one wants to view all of the possible moves
    a piece could make, simply input the location of the piece, and all of the possible
    moves will be highlighted. if one would like the game to be saved, simply input
    'save' during any turn and come back to finish later. player one will always use
    the white pieces and move first. after this message, players will be asked to
    input their desired names, and the game will commence. input anything to continue: "

  def self.introduction
    @@introduction
  end

  @@options = "    welcome to chess, what would you like to do?

                      new game          -> input 'new'
                      load a saved game -> input 'load'
                                        -> input  "

  def self.options
    @@options
  end
end