# frozen_string_literal: false

# Main class for the game
class Mastermind
  MAX_TURNS = 12
  def initialize
    @board = Array.new(12)
    @board.each_index { |index| @board[index] = Row.new }
    @turn = 0
    @answer = ColorGuess.new
  end

  def clear_board
    @board = Array.new(12)
    @board.each_index { |index| @board[index] = Row.new }
    @answer.clear
    @turn = 0
  end

  def print_board
    @board.reverse_each { |row| row.print_row }
  end

  def play_game
    clear_board
    @answer.new_code
    guess = ColorGuess.new
    while @turn < MAX_TURNS && !winner?
      guess.code = user_guess
      process_guess(guess)
      print_board
      @turn += 1
    end
    print_end_message
  end

  def print_end_message
    if winner?
      puts 'You won!'
    else
      puts 'You lost! Bettter luck next time.'
    end
  end

  def process_guess(guess)
    @board[@turn].guess.code = guess.code
    @board[@turn].guess_result.guess = compute_result(guess, @answer).guess
  end

  def compute_result(guess, answer)
    result = GuessResult.new
    result.mark_blacks(guess, answer)
    result.mark_whites(guess, answer)
    result
  end

  def user_guess
    puts 'Please enter your guess using numbers 1 to 6'
    input = gets.chomp.split('')
    # input = '1236'.split('')
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

    return true if @board[@turn - 1].code == @answer.code

    false
  end
end

# Class for one row of the board
class Row
  attr_accessor :guess, :guess_result

  def initialize
    @guess = ColorGuess.new
    @guess_result = GuessResult.new
  end

  def code
    @guess.code
  end

  def print_row
    puts "#{@guess.print}   #{@guess_result.print}"
  end
end

# Class for each guess
class ColorGuess
  attr_accessor :code

  def initialize
    @code = Array.new(4, 'X')
  end

  def print
    @code.join
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
  attr_accessor :guess

  def initialize
    @guess = Array.new(4, '.')
  end

  def print
    @guess.join
  end

  def mark(color)
    i = 0
    i += 1 until @guess[i] == '.'
    @guess[i] = color
  end

  def mark_blacks(guess, answer)
    guess.code.each_index do |index|
      next unless guess.code[index] == answer.code[index]

      mark('B')
    end
    @guess
  end

  def mark_whites(guess, answer)
    peg_used = [false, false, false, false]
    guess.code.each_index do |index|
      next if guess.code[index] == answer.code[index] # already marked black

      answer.code.each_index do |aindex|
        next unless answer.code[aindex] == guess.code[index]

        next if peg_used[aindex] || guess.code[aindex] == answer.code[aindex]

        mark('W')
        peg_used[aindex] = true
        break
      end
    end
    @guess
  end
end

test = Mastermind.new
test.play_game
