module Printable
  def prompt(message)
    puts("=> #{message}")
  end
end

class Board
  CENTER = 5

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def current_status
    @squares
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :name, :marker
  attr_accessor :score

  include Printable

  @@initial_player_marker = nil

  def initialize
    @name = set_name
    @marker = set_marker
    @score = 0
  end

  def set_name
    n = ""
    loop do
      prompt "Please input your name:"
      n = gets.chomp
      break unless n.empty?
      prompt "Please try again/"
    end
    n
  end

  def set_marker
    m = ""
    loop do
      prompt "Please choose your marker (X or O)"
      m = gets.chomp.upcase
      break if %(X O).include? m
      prompt "Please try again."
    end
    @@initial_player_marker = m
    m
  end
end

class Computer
  attr_reader :name, :marker, :opponent_marker, :move
  attr_accessor :score

  def initialize(opponent_marker)
    @name = ['R2D2', 'C3PO', 'T-100'].sample
    @marker = opponent_marker == 'X' ? 'O' : 'X'
    @score = 0
    @opponent_marker = opponent_marker
  end

  def moves(board, empty_square)
    offensive, offensive_target = find_critical_line(board, marker)
    defensive, defensive_target = find_critical_line(board, opponent_marker)
    return offensive_target if offensive
    return defensive_target if defensive
    return Board::CENTER if board[Board::CENTER] == Square::INITIAL_MARKER
    empty_square.sample
  end

  def find_critical_line(brd, marker)
    target = 0
    Board::WINNING_LINES.each do |line|
      board_line = brd.values_at(*line)
      if board_line.count(marker) == 2 &&
         board_line.count(Square::INITIAL_MARKER) == 1
        target = line.find { |pos| brd[pos] == Square::INITIAL_MARKER }
        return [true, target]
      end
    end
    [false, target]
  end
end

class TTTGame
  MAX_SCORE = 5

  attr_reader :board, :human, :computer

  include Printable

  def initialize
    clear
    display_welcome_message
    @board = Board.new
    @human = Player.new
    @computer = Computer.new(human.marker)
    @current_marker = human.marker
  end

  def play
    clear
    main_game
    display_goodbye_message
  end

  private

  def main_game
    loop do
      round_game
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def round_game
    loop do
      play_round
      if game_over?
        game_over_message
        break
      end
    end
  end

  def play_round
    display_board
    player_move
    update_players_score
    display_result
    board_reset
  end

  def game_over?
    human.score == MAX_SCORE || computer.score == MAX_SCORE
  end

  def game_over_message
    display_board
    if human.score == MAX_SCORE
      prompt "#{human.name.upcase} WINS THE GAME!"
    elsif computer.score == MAX_SCORE
      prompt "GAME OVER. #{computer.name} WINS THE GAME"
    end
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def display_welcome_message
    prompt "Welcome to the game of Tic Tac Toe!"
    prompt "First player to reach #{MAX_SCORE} wins the game."
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing tic Tac Toe! Goodbye!"
  end

  def display_board
    clear
    puts "TIC TAC TOE".center(18)
    puts ""
    puts "SCORE BOARD".center(18)
    puts "#{human.score} : (#{human.marker}) #{human.name.upcase}"
    puts "#{computer.score} : (#{computer.marker}) #{computer.name}"
    puts ""
    board.draw
    puts ""
  end

  def human_moves
    prompt "Choose a square (#{board.unmarked_keys.join(', ')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      prompt "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    brd = board.current_status.map { |key, square| [key, square.marker] }.to_h
    square_target = computer.moves(brd, board.unmarked_keys)
    board[square_target] = computer.marker
  end

  def update_players_score
    case board.winning_marker
    when human.marker
      human.score += 1
    when computer.marker
      computer.score += 1
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      prompt "You won!"
    when computer.marker
      prompt "Computer won!"
    else
      prompt "It's a tie!"
    end
    pause_screen
  end

  def pause_screen
    prompt "Press any key to continue."
    gets.chomp
  end

  def play_again?
    answer = nil
    loop do
      prompt "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      prompt "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def clear
    system 'clear'
  end

  def reset
    board.reset
    @current_marker = human.marker
    human.score = 0
    computer.score = 0
    clear
  end

  def board_reset
    board.reset
  end

  def display_play_again_message
    prompt "Let's play again!"
    puts ""
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def human_turn?
    @current_marker == human.marker
  end
end

game = TTTGame.new
game.play
