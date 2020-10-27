# frozen_string_literal: true

# Game Logic
class Game
  def initialize(player, secret_code, computer)
    @player = player
    @secret_code = secret_code
    @computer = computer
    @winner = false
    @guess = nil
    @guesses = []
    @red_pegs = 0
    @white_pegs = 0
    @colors_as_circles = []
    @guess_switch = 0
    @red_pegs_as_circle = nil
    @white_pegs_as_circle = nil
    if player == 'codebreaker'
      game_start_cb
    elsif player == 'codemaker'
      game_start_cm
    end
  end

  # Start the game as Player codebreaker.
  def game_start_cb
    puts "Try to break the computer's code in less than 8 moves!"
    i = 0
    while @winner == false && i < 8
      puts "You have #{8 - i} guesses remaining..."
      player_guess
      red_peg_check
      white_peg_check
      red_to_white_peg
      check_winner
      i += 1
    end
  if i == 8
    game_over
  end
  end
  
  # Game over display if player runs out of guesses.
  def game_over
    puts 'You have run out of guesses! Would you like to play again? (y/n)'
    answer = gets.chomp
    if answer == 'y'
      system 'clear'
      Display.new
    elsif answer == 'n'
      system 'clear'
      system 'exit'
    else
      game_over
    end
  end
  
  # Takes player input and checks validity.
  def player_guess
    print 'Red = 1, '.colorize(:red), 'Green = 2, '.colorize(:green), 'Blue = 3, '.colorize(:blue),
          'Magenta = 4, '.colorize(:magenta), 'Cyan = 5, '.colorize(:cyan), "Yellow = 6\n".colorize(:light_yellow)
    puts
    puts "Select four colours or enter 's' to show previous guesses."
    colour_selection = gets.chomp
    if colour_selection == 's'
      show_previous_guesses
      player_guess
    elsif colour_selection.length == 4 && !colour_selection.match?(/[^123456]/)
      store_colour_selection(colour_selection)
    else
      puts 'Input four numbers (1-6)'
      player_guess
    end
  end
  
  # Stores player input once all checks have passed.
  def store_colour_selection(colour_selection)
    @guess = colour_selection.to_s.chars.map(&:to_i).join(' ')
    code_to_index
  end

  def code_to_index
    @index_values = @guess.split
    @index_values = @index_values.map { |i| i.to_i - 1 }
    index_to_value
  end

  def index_to_value
    index_as_colour = @index_values.map { |e| Pattern::ORBS[e] }
    guess_as_circle(index_as_colour)
    @guess = index_as_colour.join(' ')
    @guesses.push(@guess)
    circles = @colors_as_circles.join(' ')
    puts circles
  end
  
  # Checks whether guess matches code.
  def check_winner
    if @guess == @secret_code
      @winner = true
      game_win
    end
  end
  
  # Winner announcement and display.
  def game_win
    puts 'Congratulations! You win!'
    puts "Your guess: #{@guess}"
    puts "Secret code: #{@secret_code}"
    play_again?
  end
  
  # Allows player to decide if they want to play again.
  def play_again?
    puts 'Would you like to play again? (y/n)'
    answer = gets.chomp
    if answer == 'y'
      system 'clear'
      Display.new
    elsif answer == 'n'
      system 'clear'
      system 'exit'
    else
      play_again?
    end
  end
  
  # Starts game as the codemaker.
  def game_start_cm
    puts 'Computer is attempting to break your code!'
    i = 0
    while @winner == false
      print 'Computer guess '
      print i + 1
      print '. '
      print ' Guesses remaining: '
      print 30 - i
      puts ' '
      sleep 0.5
      computer_guess
      red_peg_check
      white_peg_check
      red_to_white_peg
      winner_check
      i += 1
      computer_game_over(i)
    end
  end
  
  # Random guess is made from selection unless all four colours are valid, in which case it shuffles the colours.
  def computer_guess
    if @white_pegs == 4
      @guess = @guess.split.shuffle
    else
      @guess = Pattern::ORBS.sample(4)
    end
    @guess = @guess.join(' ')
    # Ensures that computer does not guess same code twice.
    if @guesses.any? { |i| i[@guess] } == true
      computer_guess
    else
    # Stores each valid guess.  
      @guesses.push(@guess)
      guess_as_circle(@guess.split)
      puts @colors_as_circles.join(' ')
      if @guess == @secret_code
        @winner = true
      end
    end
  end

  def winner_check
    if @winner == true
      puts 'Computer Wins!'
      puts 'Previous guesses: '
      @guess_switch = 1
      @guesses.each do |array|
        guess_as_circle(array.split)
      end
      @colors_as_circles = @colors_as_circles.each_slice(4).to_a
      @colors_as_circles.each do |a, b, c, d|
        print "#{a} #{b} #{c} #{d}\n"
      end
      play_again?
    end
  end
  
  # Allows player to see all of their previous guesses.
  def show_previous_guesses
    puts 'previous guesses: '
    @guess_switch = 1
    @guesses.each do |array|
    guess_as_circle(array.split)
                  end
    @colors_as_circles = @colors_as_circles.each_slice(4).to_a
    @colors_as_circles.each do |a, b, c, d|
      print "#{a} #{b} #{c} #{d}\n"
    end
    @guess_switch = 0
  end 
  
  # Finds how many colours match the guess.
  def white_peg_check
    guess_array = @guess.split
    secret_code_array = @secret_code.split
    intersection = (guess_array & secret_code_array)
    @white_pegs = intersection.length

  end
  
  # Finds how many colours AND locations match the guess.
  def red_peg_check
    guess_array = @guess.split
    secret_code_array = @secret_code.split
    red_pegs = guess_array.map.with_index { |e, i| e == secret_code_array[i] }
    @red_pegs = red_pegs.count(true)

  end

  def computer_game_over(i)
    if i == 30
      puts 'Computer has run out of guesses!'
      puts
      puts 'You win!'
      play_again?
    end 
  end
   
  # Converts colour values to symbol values.
  def guess_as_circle(x)
    if @guess_switch == 0
    @colors_as_circles = []
    end
    x.map { |c| convert_to_circle(c) }
  end
  
  # Stores each colour as symbol value.
  def convert_to_circle(c)

    red_circle = '●'.colorize(:red)
    green_circle = '●'.colorize(:green)
    blue_circle = '●'.colorize(:blue)
    magenta_circle = '●'.colorize(:magenta)
    cyan_circle = '●'.colorize(:cyan)
    yellow_circle = '●'.colorize(:yellow)

    if c == 'Red'
      c = red_circle
    elsif c == 'Green'
      c = green_circle
    elsif c == 'Blue'
      c = blue_circle
    elsif c == 'Magenta'
      c = magenta_circle
    elsif c == 'Cyan'
      c = cyan_circle
    elsif c == 'Yellow'
      c = yellow_circle
    end
    @colors_as_circles.push(c)
  end
  
  # Stores red peg values as symbols.
  def red_pegs_as_circle
    @red_peg_as_circle = nil

    if @red_pegs == 0
      @red_peg_as_circle = nil
    elsif @red_pegs == 1
      @red_peg_as_circle = '●'.colorize(:red)
    elsif @red_pegs == 2
      @red_peg_as_circle = '● ●'.colorize(:red)
    elsif @red_pegs == 3
      @red_peg_as_circle = '● ● ●'.colorize(:red)
    elsif @red_pegs == 4
      @red_peg_as_circle = '● ● ● ●'.colorize(:red)
    end
  end
  
  # Stores white peg values as symbols.
  def white_pegs_as_circle
    @white_pegs_as_circle = nil

    if @white_pegs == 0
      @white_pegs_as_circle = nil
    elsif @white_pegs == 1
      @white_pegs_as_circle = '●'.colorize(:white)
    elsif @white_pegs == 2
      @white_pegs_as_circle = '● ●'.colorize(:white)
    elsif @white_pegs == 3
      @white_pegs_as_circle = '● ● ●'.colorize(:white)
    elsif @white_pegs == 4
      @white_pegs_as_circle = '● ● ● ●'.colorize(:white)
    end
  end

  def red_to_white_peg
    show_pegs
  end
  
  # Displays red and white peg values
  def show_pegs
    white_pegs_as_circle
    red_pegs_as_circle
    puts @white_pegs_as_circle
    puts @red_peg_as_circle 
  end 
end
