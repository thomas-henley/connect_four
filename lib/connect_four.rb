# lib/connect_four.rb

require_relative './player'
require 'pry-byebug'

class ConnectFour
  attr_accessor :board, :p1, :p2

  def initialize
    self.board = Array.new(6) { Array.new(7) }
    self.p1 = 'X'
    self.p2 = 'O'
  end

  def place_piece(player, column)
    # Check for available slot in column
    5.downto(0) do |i|
      if board[i][column].nil?
        board[i][column] = player
        return i
      end
    end

    # Return nil if the column is full
    nil
  end

  def take_turn(player)
    slot = nil
    until (0..6).include?(slot) && place_piece(player, slot)
      print "Player #{player}, select slot: "
      slot = gets.chomp
      slot = slot.to_i if slot.to_i.to_s == slot
    end
    slot
  end

  def play
    puts " CONNECT FOUR "
    puts "==============\n"
    loop do
      take_turn(p1)
      display_board
      end_game(p1) if check_for_win
      draw if is_a_draw?
      take_turn(p2)
      display_board
      end_game(p2) if check_for_win
      draw if is_a_draw?
    end
  end

  def draw
    puts "It's a draw! Goodbye."
    exit(true)
  end

  def end_game(player)
    puts "#{player} wins! Congratulations!"
    exit(true)
  end

  def is_a_draw?
    board.flatten.none? { |square| square.nil? }
  end

  def check_for_win
    check_for_vertical_win || check_for_horizontal_win || check_for_NW_SE_win || check_for_NE_SW_win
  end

  def check_for_vertical_win
    0.upto(2) do |row|
      board[row].each_with_index do |element, col|
        next if element.nil?
        if [board[row][col], board[row+1][col], board[row+2][col], board[row+3][col]].uniq.length == 1
          return [[row,col], [row+1,col], [row+2,col], [row+3,col]]
        end
      end
    end
    nil
  end

  def check_for_horizontal_win
    0.upto(5) do |row|
      0.upto(3) do |col|
        next if board[row][col].nil?
        if [board[row][col], board[row][col + 1], board[row][col + 2], board[row][col + 3]].uniq.length == 1
          return [[row, col],[row, col+1],[row, col+2],[row, col+3]]
        end
      end
    end
    nil
  end

  def check_for_NW_SE_win
    0.upto(2) do |row|
      0.upto(3) do |col|
        next if board[row][col].nil?
        coords = (0..3).map { |i| [row + i, col + i] }
        return coords if coords.map { |coord| board[coord[0]][coord[1]] }.uniq.length == 1
      end
    end
    nil
  end

  def check_for_NE_SW_win
    0.upto(2) do |row|
      3.upto(6) do |col|
        next if board[row][col].nil?
        coords = (0..3).map { |i| [row + i, col - i] }
        return coords if coords.map { |coord| board[coord[0]][coord[1]] }.uniq.length == 1
      end
    end
    nil
  end

  def display_board
    output = ''

    for row in board
      for square in row
        output << "|#{square ? square : ' '}"
      end
      output << "|\n"
    end

    output << "+-+-+-+-+-+-+-+\n"
    print output
  end
end

game = ConnectFour.new
game.play