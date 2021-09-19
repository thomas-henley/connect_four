require './lib/connect_four.rb'
require 'stringio'
require 'pry'

describe ConnectFour do
  before(:each) { @game = ConnectFour.new() }

  describe "constructor" do
    it "generates an empty @board" do
      empty_board = Array.new(6) { Array.new(7) }
      expect(@game.board).to eql empty_board
    end

    it "generates player @p1" do
      expect(@game.p1).to eql 'X'
    end

    it "generates player @p2" do
      expect(@game.p2).to eql 'O'
    end
  end

  describe "#display_board" do
    it "can print an empty board" do
      b = ""
      b << "| | | | | | | |\n"
      b << "| | | | | | | |\n"
      b << "| | | | | | | |\n"
      b << "| | | | | | | |\n"
      b << "| | | | | | | |\n"
      b << "| | | | | | | |\n"
      b << "+-+-+-+-+-+-+-+\n"
      expect { @game.display_board }.to output(b).to_stdout
    end

    it "can print a board with pieces" do
      b = ""
      b << "| | | | | | | |\n"
      b << "| | | | | | | |\n"
      b << "| | | | | | | |\n"
      b << "| | | | | | | |\n"
      b << "| | |X|O| |X| |\n"
      b << "|O|X|O|X|X|O|O|\n"
      b << "+-+-+-+-+-+-+-+\n"

      @game.board = [
        Array.new(7),
        Array.new(7),
        Array.new(7),
        Array.new(7),
        [nil, nil, 'X', 'O', nil, 'X', nil],
        ['O', 'X', 'O', 'X', 'X', 'O', 'O']
      ]
      
      expect { @game.display_board }.to output(b).to_stdout
    end
  end

  describe "#place_piece" do
    it "drops a piece to the bottom of an empty board" do
      @game.place_piece(@game.p1, 5)
      expect(@game.board[5][5]).to eql 'X'
    end

    it "only adds one piece" do
      @game.place_piece(@game.p1, 5)
      expect(@game.board.flatten.count { |i| i }).to eql 1
    end

    it "drops a piece on top of another piece" do
      @game.place_piece(@game.p1, 5)
      @game.place_piece(@game.p2, 5)
      expect(@game.board[4][5]).to eql 'O'
    end

    it "returns the row the piece is placed on" do
      @game.place_piece(@game.p1, 5)
      expect(@game.place_piece(@game.p2, 5)).to eql 4
    end

    it "returns nil on a full column" do
      0.upto(5) do |i|
        @game.board[i][5] = 'X'
      end
      expect(@game.place_piece(@game.p1, 5)).to be_nil
    end
  end

  describe "#is_a_draw?" do
    it "returns true when the board is full with no winner" do
      mark = 0
      @game.board = Array.new(6) { Array.new(7) { mark += 1 } }
      expect(@game.is_a_draw?).to be true
    end

    it "returns false when the board is not full" do
      mark = 0
      @game.board = Array.new(6) { Array.new(7) { mark += 1} }
      @game.board[0][2] = nil
      expect(@game.is_a_draw?).to be false
    end
  end

  describe "#check_for_win" do
    it "returns nil if there is no win" do
      3.upto(5) { |i| @game.board[i][2] = 'X' }
      @game.board[5][0] = @game.board[5][1] = @game.board[5][3] = 'O'
      expect(@game.check_for_win).to be_nil
    end

    it "returns a vertical four" do
      2.upto(5) { |i| @game.board[i][2] = 'X' }
      @game.board[5][0] = @game.board[5][1] = @game.board[5][3] = 'O'
      expect(@game.check_for_win).to eql [[2,2], [3,2], [4,2], [5,2]]
    end

    it "returns a horizontal four" do
      2.upto(5) { |i| @game.board[5][i] = 'X' }
      @game.board[5][0] = @game.board[5][1] = @game.board[5][6] = 'O'
      expect(@game.check_for_win).to eql [[5,2],[5,3],[5,4],[5,5]]
    end

    it "returns a NE-SW diagonal four" do
      2.upto(5) { |i| @game.board[i][-i] = 'X' }
      expect(@game.check_for_win).to eql [[2,5],[3,4],[4,3],[5,2]]
    end

    it "returns a NW-SE diagonal four" do
      2.upto(5) { |i| @game.board[i][i] = 'X' }
      expect(@game.check_for_win).to eql [[2,2],[3,3],[4,4],[5,5]]
    end
  end

  describe "#display_win" do

  end

  describe "#take_turn" do
    it "outputs player prompt" do
      $stdin = StringIO.new('4')
      expect { @game.take_turn(@game.p1) }.to output(
        "Player X, select slot: "
      ).to_stdout
      $stdin = STDIN
    end

    it "returns the slot number the player enters" do
      $stdin = StringIO.new('4')
      $stdout = StringIO.new
      expect(@game.take_turn(@game.p1)).to eql(4)
      $stdin = STDIN
      $stdout = STDOUT
    end
  end
end