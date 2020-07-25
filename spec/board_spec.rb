require './lib/board'

describe Board do
  describe '#move_piece' do
    it 'places the selected piece on the selected square, if the move is possible' do
      board = Board.new
      board.move_piece('a2:a4')
      expect(board.display[4][0].guest.display).to eql("\u265f".encode('utf-8'))
      expect(board.display[6][0].guest).to eql(' ')
    end
  end

  it 'allows for pawns to attack pieces of the opposite color in a diagonal manner' do
    board = Board.new
    board.move_piece('c2:c4')
    board.move_piece('d7:d5')
    board.move_piece('b2:b4')
    board.move_piece('b4:b5')
    expect(board.move_piece('c4:b5')).to eql(false)
    board.move_piece('c4:d5')
    expect(board.display[3][3].guest.display).to eql("\u265f".encode('utf-8'))
  end

  it 'does not allow pawns to move diagonally except for attacking' do
    board = Board.new
    expect(board.move_piece('b7:a6')).to eql(false)
  end

  it 'does not let a player make illegal moves' do
    board = Board.new
    expect(board.move_piece('a1:a4')).to eql(false)
    expect(board.move_piece('d1:f3')).to eql(false)
  end

  it 'does not let a player make a move that puts them in check' do
    board = Board.new
    board.move_piece('d7:d5')
    board.move_piece('b2:b4')
    board.move_piece('e8:a4')
    expect(board.move_piece('c2:c3')).to eql(false)
  end

  describe '#checkmate' do
    it 'returns true if a player cannot make any moves to get their king out of check' do
      board = Board.new
      board.move_piece('c2:c3')
      board.move_piece('d7:d5')
      board.move_piece('b2:b4')
      board.move_piece('e8:a4')
      expect(board.checkmate('white')).to eql(true)

      board2 = Board.new
      board2.move_piece('e2:e4')
      board2.move_piece('b8:c6')
      board2.move_piece('g1:e2')
      board2.move_piece('d7:d5')
      board2.move_piece('e4:d5')
      board2.move_piece('c6:b4')
      board2.move_piece('a2:a3')
      board2.move_piece('b4:d3')
      board2.move_piece('c2:d3')
      board2.move_piece('e8:a4')
      board2.move_piece('b2:b3')
      board2.move_piece('a4:b3')

      expect(board2.checkmate('white')).to eql(true)
    end

    it 'returns false if a player can make a move to get their king out of check' do
      board = Board.new
      expect(board.checkmate('white')).to eql(false)

      board.move_piece('c2:c3')
      board.move_piece('d7:d6')
      board.move_piece('g1:h3')
      board.move_piece('e8:a4')
      expect(board.checkmate('white')).to eql(false)
    end
  end
end
