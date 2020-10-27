# frozen_string_literal: true

# Set roles of player and computer
class Player
  def initialize
    @player = nil
    @computer = nil
    choose_role
  end

  def choose_role
    print 'Do you want to play as the ', 'codemaker'.colorize(:green).bold, ' or the ', 'codebreaker?'.colorize(:red).bold, "(cm/cb)\n"
    role = gets.chomp
    assign_role(role)
  end
  
  # Ensures selection is valid and sets value for game instance
  def assign_role(role)
    if role == 'cm'
      @player = 'codemaker'
      @computer = 'codebreaker'
      announce_role
    elsif role == 'cb'
      @player = 'codebreaker'
      @computer = 'codemaker'
      announce_role
    else
      puts "Invalid Selection. Either choose 'cb' or 'cm'."
      choose_role
    end
  end
  
  # Displays player choice and moves to code creation
  def announce_role
    if @player == 'codebreaker'
      puts
      puts 'You are the CODEBREAKER!'
    elsif @player == 'codemaker'
      puts
      puts 'you are the CODEMAKER!'
    end
    Pattern.new(@computer, @player)
  end
end
