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

  def play_game
    clear_board
    if human_game?
      play_human_game
    else
      play_computer_game
    end
  end

  private

  def print_board
    @board.reverse_each { |row| row.print_row }
  end

  def play_human_game
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

  def play_computer_game
    @answer.code = "1234".split('') # human_code
    possible_guesses = initial_possible_guesses
    until winner?
      computer_guess = ColorGuess.new
      computer_guess.code = "1122".split('')
      # computer_guess = next_guess(possible_guesses)
      guess_result = process_guess(computer_guess)
      possible_guesses = reduce_guesses(possible_guesses, computer_guess, guess_result)
      print_computer_guess
      print_board
      @turn += 1
    end
  end

  def reduce_guesses(possible_guesses, computer_guess, guess_result)
    possible_guesses.select { |guess| compute_result(guess, computer_guess).guess == guess_result.guess }
  end

  def human_code
    puts 'Please enter the 4 digit secret code using the numbers 1-6'
    gets.chomp
  end

  def initial_possible_guesses
    array_of_guesses = []
    array_of_digits = %w[1 2 3 4 5 6]
    array_of_digits.each do |a|
      array_of_digits.each do |b|
        array_of_digits.each do |c|
          array_of_digits.each do |d|
            array_of_guesses.push(ColorGuess.new(a + b + c + d))
          end
        end
      end
    end
    array_of_guesses
  end

  def human_game?
    return false
    # puts '(H)uman or (C)omputer codebreaker?'
    # return true if gets.chomp == 'H'

    # false
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
    @board[@turn].guess_result = compute_result(guess, @answer)
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

  # def initialize
  #   @code = Array.new(4, 'X')
  # end

  def initialize(code_string = nil)
    @code = if code_string.nil?
              Array.new(4, 'X')
            else
              Array.new(code_string.split(''))
            end
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
