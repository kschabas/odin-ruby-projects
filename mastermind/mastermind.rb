# frozen_string_literal: false

# Main class for the game
class Mastermind
  MAX_TURNS = 12
  def initialize
    @board = Array.new(12, Row.new)
    @turn = 0
    @answer = ColorGuess.new
  end

  def clear_board
    @board = Array.new(12, Row.new)
    @answer.clear
    @turn = 0
  end

  def play_game
    clear_board
    @answer.new_code
    while @turn <= MAX_TURNS && !winner?
      guess = user_guess
      process_guess(guess, @answer)
      print_board?
      @turn += 1
    end
    print_end_message
  end

  def user_guess
    puts 'Please enter your guess using numbers 1 to 6'
    # input = gets.chomp.split('')
    input = "1236".split('')
    input = input.map { |item| item.to_i }
    until valid_input?(input)
      puts 'Bad input! Please try again'
      input = gets.chomp.split('')
    end
    input
  end

  def valid_input?(input)
    input.all? { |e| e.between?(1, 6) }
  end

  def winner?
    return false if @turn.zero?

    return true if @board[turn - 1].code == @answer

    false
  end
end

# Class for one row of the board
class Row
  def initialize
    @guess = ColorGuess.new
    @guess_result = GuessResult.new
  end

  def code
    @guess.code
  end
end

# Class for each guess
class ColorGuess
  attr_accessor :code

  def initialize
    @code = Array.new(4, 'X')
  end

  def clear
    @code = %w[X X X X]
  end

  def new_code
    @code.each_index { |index| @code[index] = rand(1..6) }
  end
end

# Result of each guess
class GuessResult
  def initialize
    @guess = Array.new(4, '.')
  end
end

test = Mastermind.new
test.play_game
