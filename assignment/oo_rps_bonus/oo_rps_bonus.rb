require 'pry'

WINDOW_WIDTH = 47
MAX_SCORE = 3

module Printable
  def prompt(message)
    puts("=> #{message}")
  end

  def display_welcome_message
    prompt "Welcome to the Rock, Paper, Scissors, Lizard, Spock game!"
  end

  def display_goodbye_message
    prompt "Thank you for playing. Good bye!"
  end

  def press_key_to_continue
    prompt "Press any key to continue"
    gets.chomp
  end

  def display_select_move_message
    prompt 'Please make your choice by entering the full value or its diminutive'
    Move::VALUES.each do |value, set|
      prompt("   #{value.to_s.ljust(8)} (or #{set[:abbreviation]})")
    end
  end

  def display_winner
    if human.move.to_s == computer.move.to_s
      prompt "It's a tie!"
    elsif human.move > computer.move
      prompt "#{human.name} wins this round!"
    else
      prompt "#{computer.name} wins this round!"
    end
  end
end

class Move
  attr_reader :value

  VALUES = {
    rock: { abbreviation: :r, beats: [:lizard, :scissors] },
    paper: { abbreviation: :p, beats: [:rock, :spock] },
    scissors: { abbreviation: :sc, beats: [:paper, :lizard] },
    spock: { abbreviation: :sp, beats: [:scissors, :rock] },
    lizard: { abbreviation: :l, beats: [:spock, :paper] }
  }

  def initialize(value)
    @value = value
  end

  def >(other_move)
    VALUES[@value][:beats].include?(other_move.value)
  end

  def to_s
    @value.to_s
  end
end

class Player
  attr_accessor :move, :name

  include Printable

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      prompt "Please input your name?"
      n = gets.chomp
      break unless n.empty?
      prompt "Please try again"
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      display_select_move_message
      choice = gets.chomp.downcase.to_sym

      if Move::VALUES.key?(choice) ||
         Move::VALUES.any? { |_, diminutive| diminutive[:abbreviation] == choice }
        if Move::VALUES.any? { |_, diminutive| diminutive[:abbreviation] == choice }
          choice = Move::VALUES.find { |_, value| value[:abbreviation] == choice }[0]
        end
        break
      else
        prompt "Please try again"
      end
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  attr_accessor :human_move_history, :computer_move_history

  def set_name
    self.name = ['R2D2', 'C3PO', 'Bard', 'T-100'].sample
    # R2D2  = plays normally
    # C3PO  = plays the move - 1 of the user
    # Bard  = plays the same move
    # T-100 = plays the classic rock, paper, scissors
    prompt "Your opponent is #{name}"
    press_key_to_continue
  end

  def opponent_game_history(human_move_history)
    @human_move_history = human_move_history
  end

  def computer_game_history(computer_move_history)
    @computer_move_history = computer_move_history
  end

  def choose
    sample_move = Move::VALUES.keys.sample
    case name
    when 'R2D2'
      self.move = Move.new(sample_move)
    when 'C3PO'
      which_move = human_move_history.empty?
      opponent_move = human_move_history[-1]
      self.move = which_move ? Move.new(sample_move) : Move.new(opponent_move)
    when 'Bard'
      which_move = computer_move_history.empty?
      computer_move = computer_move_history[-1]
      self.move = which_move ? Move.new(sample_move) : Move.new(computer_move)
    when 'T-100'
      self.move = Move.new([:rock, :paper, :scissors].sample)
    end
  end
end

# Game Orchestration Engine
class RPSGame
  attr_accessor :human_score, :computer_score, :winner, :human_move_history,
                :computer_move_history
  attr_reader :human, :computer

  include Printable

  def move_history(human_move, computer_move)
    human_move_history << human_move
    computer_move_history << computer_move
    @computer.opponent_game_history(@human_move_history)
  end

  def initialize
    system 'clear'
    display_welcome_message
    @human = Human.new
    @computer = Computer.new
    @human_score = 0
    @computer_score = 0
    @human_move_history = []
    @computer_move_history = []
    @computer.opponent_game_history(@human_move_history)
    @computer.computer_game_history(@computer_move_history)
  end

  def display_moves
    prompt "#{human.name} chose #{human.move}."
    prompt "#{computer.name} chose #{computer.move}."
  end

  def update_score
    move_history(human.move.value, computer.move.value)
    if human.move > computer.move
      self.human_score += 1
    elsif computer.move > human.move
      self.computer_score += 1
    end
  end

  def update_winner
    self.winner = human.name if human_score == MAX_SCORE
    self.winner = computer.name if computer_score == MAX_SCORE
  end

  def display_last_moves
    half_width = (WINDOW_WIDTH - 5) / 2
    lines = []

    puts "|#{'LAST MOVES'.center(WINDOW_WIDTH - 2)}|"
    human_move_history.reverse_each.with_index do |move, index|
      left_str = "#{-index - 1} #{move.to_s.rjust(12)}"
      left_str = left_str.rjust(half_width)
      right_str = computer_move_history[-index - 1].to_s.ljust(half_width)
      lines << "|#{left_str} - #{right_str}|"
      break if index == human_move_history.size - 1
      break if index == 2
    end
    lines.reverse_each { |line| puts line }
    puts "|#{' ' * (WINDOW_WIDTH - 2)}|"
  end

  def display_score
    half_width = (WINDOW_WIDTH - 5) / 2
    frame = "+#{'-' * (WINDOW_WIDTH - 2)}+"
    left_str = "#{human.name.slice(0, half_width - 5).upcase} [#{human_score}"
    right_str = "#{computer_score}] #{computer.name.slice(0, half_width - 5).upcase}"
    left_str = "|#{left_str.rjust(half_width - 1)}"
    right_str = "#{right_str.ljust(half_width - 1)}|"
    if !winner.nil?
      winner_str = "|#{("GAME WINNER: #{winner.upcase}").center(WINDOW_WIDTH - 2)}|"
    end

    puts frame
    display_last_moves
    puts "|#{'SCORE BOARD'.center(WINDOW_WIDTH - 2)}|"
    puts "#{left_str}] - [#{right_str}"
    puts winner_str unless winner.nil?
    puts frame
  end

  def play_again?
    answer = nil
    loop do
      prompt "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer[0].downcase
      prompt "Sorry, please input yes or no."
    end

    return false if answer.downcase == 'n'
    self.human_score = 0
    self.computer_score = 0
    self.human_move_history = []
    self.computer_move_history = []
    @computer.opponent_game_history(@human_move_history)
    @computer.computer_game_history(@computer_move_history)
    self.winner = nil
    return true if answer == 'y'
  end

  def play
    loop do
      loop do
        system 'clear'
        display_score
        human.choose
        computer.choose
        system 'clear'
        update_score
        update_winner
        display_score
        display_moves
        display_winner
        press_key_to_continue if winner.nil?
        break unless winner.nil?
      end
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
