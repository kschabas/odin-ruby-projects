# frozen_string_literal: false

# class to take care of game
class Game
  def initialize
    @board = Board.new
    @turn = 1
  end

  def play_game
    @board.clear
    until @board.winner?
      (coord = get_input(@turn)) until @board.set_move(coord.split(','), @turn)
      @turn = (@turn + 1) % 2
    end
  end

  def get_input
    print "Player #{@turn}: Please enter move as x,y"
    gets.chomp
  end
end

# Tic tac toe board class
class Board
  def initialize
    @board = Array.new(3, Array.new(3, ' '))
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

  def set_move(coord, turn)
    return false if coord.length != 2 || !coord.between(0, 2) || !coord.between(0, 2)

    char = turn == 1 ? 'X' : 'O'
    @board[coord[0], coord[1]] = char
    true
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
