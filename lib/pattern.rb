# frozen_string_literal: true

# Generates codes for either computer or player.
class Pattern
  ORBS = %w[Red Green Blue Magenta Cyan Yellow].freeze

  def initialize(computer, player)
    @computer = computer
    @player = player
    @secret_code = nil
    @index_values = nil
    if player == 'codebreaker'
      create_secret_code
    elsif player == 'codemaker'
      enter_code
    end
  end

  # Takes four unique colours from choice and shuffles them.
  def create_secret_code
    @secret_code = ORBS.sample(4).join(' ')
    puts 'Computer code has generated!'
    Game.new(@player, @secret_code, @computer)
  end

  # Takes player input for created code and validates legality.
  def enter_code
    puts
    print 'Red = 1, '.colorize(:red), 'Green = 2, '.colorize(:green), 'Blue = 3, '.colorize(:blue),
          'Magenta = 4, '.colorize(:magenta), 'Cyan = 5, '.colorize(:cyan), "Yellow = 6\n".colorize(:light_yellow)
    puts
    puts 'Select four colours'
    colour_selection = gets.chomp
    duplicate_check(colour_selection)
    if colour_selection.length == 4 && !colour_selection.match?(/[^123456]/)
      store_colour_selection(colour_selection)
    else
      system 'clear'
      puts 'Input four numbers'
      enter_code
    end
  end

  # Ensures no duplicate colours.
  def duplicate_check(colour_selection)
    colours = colour_selection.split('')
    if colours.uniq.length != colours.length
      system 'clear'
      puts 'No duplicate colours allowed!'
      enter_code
    end
  end
  
  # Stores selection
  def store_colour_selection(colour_selection)
    @secret_code = colour_selection.to_s.chars.map(&:to_i).join(' ')
    code_to_index
  end
  
  # Converts input numbers to index values of ORBS array.
  def code_to_index
    @index_values = @secret_code.split
    @index_values = @index_values.map { |i| i.to_i - 1 }
    index_to_value
  end
  
  # Converts index values to corresponding string values of ORBS.
  def index_to_value
    index_as_colour = @index_values.map { |e| ORBS[e] }
    @secret_code = index_as_colour.join(' ')
    puts 'Your code is: ' + @secret_code
    Game.new(@player, @secret_code, @computer)
  end
end
