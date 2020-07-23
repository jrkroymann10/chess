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
    board.move_piece('d7:d6')
    board.move_piece('g1:h3')
    board.move_piece('e8:a4')
    board.move_piece('b1:a3')
    board.move_piece('a4:h4')
    expect(board.move_piece('f2:f3')).to eql('invalid move, you cannot put yourself in check')
  end
end
