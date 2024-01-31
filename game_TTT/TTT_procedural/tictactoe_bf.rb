WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/methodLength, Metrics/AbcSize
def display_board(brd, header)
  system 'clear'
  puts "TIC TAC TOE".center(30)
  puts ""
  puts "SCORE BOARD".center(30)
  puts "PLAYER01 (#{PLAYER_MARKER}) : #{header[0]}".center(30)
  puts "COMPUTER (#{COMPUTER_MARKER}) : #{header[1]}".center(30)
  puts ""
  puts "     |     |     ".center(30)
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  ".center(30)
  puts "     |     |     ".center(30)
  puts "-----+-----+-----".center(30)
  puts "     |     |     ".center(30)
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  ".center(30)
  puts "     |     |     ".center(30)
  puts "-----+-----+-----".center(30)
  puts "     |     |     ".center(30)
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  ".center(30)
  puts "     |     |     ".center(30)
  puts ""
end
# rubocop:enable Metrics/methodLength, Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))})"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd, target = '')
  if target == ''
    square = empty_squares(brd).sample
    brd[square] = COMPUTER_MARKER
  else
    brd[target] = COMPUTER_MARKER
  end
end

def computer_move_strategy(brd)
  offensive, offensive_target = empty_position_line(brd, COMPUTER_MARKER)
  defensive, defensive_target = empty_position_line(brd, PLAYER_MARKER)
  if offensive == true
    computer_places_piece!(brd, offensive_target)
  elsif defensive == true
    computer_places_piece!(brd, defensive_target)
  elsif brd[5] == INITIAL_MARKER
    computer_places_piece!(brd, 5)
  else
    computer_places_piece!(brd)
  end
end

def alternate_player(current_player)
  case current_player
  when :player then :computer
  when :computer then :player
  end
end

def place_piece!(brd, current_player)
  case current_player
  when :player then player_places_piece!(brd)
  when :computer then computer_move_strategy(brd)
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)[0]
end

def empty_position_line(brd, marker)
  target = 0
  WINNING_LINES.each do |line|
    brd_line = brd.values_at(line[0], line[1], line[2])
    if brd_line.count(marker) == 2 && brd_line.count(INITIAL_MARKER) == 1
      brd_line.each_with_index do |element, index|
        target = line[index] if element == INITIAL_MARKER
      end
      return [true, target]
    end
  end
  [false, target]
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player', :player
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer', :computer
    end
  end
  return nil, nil
end

def joinor(array, separator = ', ', word = 'or')
  return array[0] if array.size == 1
  separator = ' ' if array.size == 2
  "#{array[0..-2].join(separator)}#{separator}#{word} #{array[-1]}"
end

def update_score(brd, player_score, computer_score)
  player_score += 1 if detect_winner(brd)[0] == "Player"
  computer_score += 1 if detect_winner(brd)[0] == "Computer"
  [player_score, computer_score]
end

def update_board(brd, current_player, player_score, computer_score)
  loop do
    display_board(brd, [player_score, computer_score])
    place_piece!(brd, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(brd) || board_full?(brd)
  end
  current_player
end

def next_player(current_player, player_score, computer_score)
  if player_score > computer_score
    :computer
  elsif player_score < computer_score
    :player
  else
    alternate_player(current_player == :computer ? :player : :computer)
  end
end

loop do
  system 'clear'
  puts 'Welcome to the game of Tic Tac Toe'
  board = initialize_board
  player_score = 0
  computer_score = 0
  prompt "Do you want to play the first move? (y/n)"
  current_player = (gets.chomp.downcase == 'y' ? :player : :computer)

  loop do
    board = initialize_board

    current_player = update_board(board, current_player, player_score, computer_score)
    player_score, computer_score = update_score(board, player_score, computer_score)
    display_board(board, [player_score, computer_score])
    prompt someone_won?(board) ? "#{detect_winner(board)[0]} wins!" : "It's a tie!"

    current_player = next_player(current_player, player_score, computer_score)
    prompt "On next round, #{current_player} moves first"

    if player_score == 5 || computer_score == 5
      prompt "PLAYER WINS THE GAME!" if player_score == 5
      prompt "GAME OVER. COMPUTER WINS THE GAME!" if computer_score == 5
      break
    end

    prompt "Press any key to continue"
    gets.chomp
  end

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing Tic Tac Toe! Good Bye!"
