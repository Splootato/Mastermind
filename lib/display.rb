# frozen_string_literal: true

# Visual display
class Display
  def initialize
    game_title
    Player.new
  end
  
  # Displays Welcome screen and rules

  def game_title
    print 'Welcome to ', "MASTERMIND.\n".colorize(:magenta).bold
    sleep 1
    puts
    puts 'The rules of the game are simple...'
    sleep 1
    puts
    print 'First you select whether you would like to be the ', 'codemaker'.colorize(:green).bold, ' or the ',
          "codebreaker.\n".colorize(:red).bold
    sleep 1
    puts
    print 'The ', 'codemaker'.colorize(:green).bold,
          ' selects four colours in order which must then be guessed by the ', "codebreaker.\n".colorize(:red).bold
    print 'After each guess as the ', 'codebreaker'.colorize(:red).bold,  ' you will be shown how many ',
          'Red Pegs'.colorize(:light_red).bold, ' and ', 'White Pegs '.bold, "you have achieved from that guess.\n"
    puts
    print 'Each ', 'Red Peg'.colorize(:red).bold,
          " means that you have correctly guessed the color as well as the placement of one of the colours in the code.\n"
    print 'Each ', 'White Peg'.bold,
          " means that you have correctly guessed a colour but not the location of one of the colours in the code.\n"
    sleep 1
    puts
    puts "As the player you get 8 tries to crack the computer's code."
    puts 'The computer is not very smart so to make things fair it gets 30 tries to crack your code.'
    puts
    puts "Let's begin!"
    puts
  end
end
