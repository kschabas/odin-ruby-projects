# frozen_string_literal: false

# Tic tac toe board class
class Board
  def initialize
    @board = Array.new(3, Array.new(3, ''))
    @turn = 1
  end

  def clear_board
    @board.each_index { |index| @board[index] = [' ', ' ', ' '] }
  end

  def print_board
    @board.each_index do |index|
      print_line(@board[index])
      print_line('-') unless index == 2
    end
  end

  private

  def print_line(line)
    if line == '-'
      puts '---------'
    else
      puts " #{line[0]} | #{line[1]} | #{line[2]} "
    end
  end
end

test = Board.new
test.print_board
