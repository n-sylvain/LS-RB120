CARD_VALUE = {
  "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8,
  "9" => 9, "10" => 10, "jack" => 10, "queen" => 10, "king" => 10, "ace" => 11
}
GAME_LIMIT = 21
DEALER_LIMIT = 17

def prompt(msg)
  puts "=>  #{msg}"
end

def initialize_deck
  new_deck = []

  ['hearts', 'diamonds', 'clubs', 'spades'].each do |suits|
    (('2'..'10').to_a + ['jack', 'queen', 'king', 'ace']).each do |values|
      new_deck << [suits, values]
    end
  end

  new_deck
end

# rubocop:disable Metrics/methodLength, Metrics/AbcSize
def display_board(dealer_cards, dealer_score,
                  player_cards, player_score, hide: false)
  system 'clear'
  puts "#{GAME_LIMIT} (light version)".center(26)
  puts ''
  puts 'SCORE BOARD'.center(26)
  puts "DEALER: #{dealer_score}".center(26)
  puts "PLAYER: #{player_score}".center(26)
  puts ''
  puts ''
  puts "DEALER's CARDS".center(26)
  if hide
    puts "deck value : #{update_hand_value(dealer_cards, hide: true)}".center(26)
    puts display_deck(dealer_cards, hide: true)
  else
    puts "deck value : #{update_hand_value(dealer_cards)}".center(26)
    puts display_deck(dealer_cards)
  end
  puts ''
  puts ''
  puts display_deck(player_cards)
  puts "deck value : #{update_hand_value(player_cards)}".center(26)
  puts "PLAYER's CARDS".center(26)
  puts ''
end
# rubocop:enable Metrics/methodLength, Metrics/AbcSize

def display_deck(table_deck, hide: false)
  line_a = '+-----------' * table_deck.size
  line_b = '|           ' * table_deck.size
  line1 = ''
  line2 = ''
  table_deck.each_with_index do |card, index|
    if hide && index > 0
      line1 += "| #{'hidden'.center(10)}"
      line2 += "| #{' '.center(10)}"
    else
      line1 += "| #{card[0].capitalize.center(10)}"
      line2 += "| #{card[1].capitalize.center(10)}"
    end
  end
  ["#{line_a}+", "#{line_b}|", "#{line_b}|", "#{line1}|", "#{line_b}|",
   "#{line2}|", "#{line_b}|", "#{line_b}|", "#{line_a}+"]
end

def update_hand_value(table_deck, hide: false)
  return CARD_VALUE[table_deck[0][1]] if hide

  values = []
  aces = []
  table_deck.each do |card|
    values << CARD_VALUE[card[1]] if card[1] != "ace"
    aces << "ace" if card[1] == "ace"
  end

  result = values.sum

  case aces.size
  when 4 then result = (14 + result > GAME_LIMIT ? result + 4 : result + 14)
  when 3 then result = (13 + result > GAME_LIMIT ? result + 3 : result + 13)
  when 2 then result = (12 + result > GAME_LIMIT ? result + 2 : result + 12)
  when 1 then result = (11 + result > GAME_LIMIT ? result + 1 : result + 11)
  end
  # while aces.size > 0 # needs to update, does not handle edge case of more than 2 aces.
  #   result = (11 + result > GAME_LIMIT ? result + 1 : result + 11) if aces.size == 1
  #   aces.pop
  # end

  result
end

def initial_card_distribution(deck, dealer_cards, player_cards)
  1.upto(4) do |index|
    player_cards << distribute_card!(deck) if index.even?
    dealer_cards << distribute_card!(deck) if index.odd?
  end
end

def distribute_card!(deck)
  deck.delete(deck.sample)
end

def player_choice
  move = ''
  loop do
    prompt "Press 1 to 'HIT', press 2 to for 'STAY'"
    move = gets.chomp.to_i
    break if [1, 2].include?(move)
    prompt "Sorry, that's not a valid choice."
  end
  move
end

def player_cards_update(player_cards, deck)
  player_cards << distribute_card!(deck)
  player_cards
end

def round_score_update(dealer_hand_value, player_hand_value,
                       dealer_score, player_score)
  if dealer_hand_value <= GAME_LIMIT && dealer_hand_value > player_hand_value
    prompt "DEALER wins this round."
    dealer_score += 1
  elsif dealer_hand_value > GAME_LIMIT || player_hand_value > dealer_hand_value
    prompt "PLAYER wins this round!"
    player_score += 1
  elsif player_hand_value == dealer_hand_value
    prompt "It's a draw!"
  end
  [dealer_score, player_score]
end

# START
loop do
  dealer_score = 0
  player_score = 0

  system 'clear'
  puts "Welcome to the game of #{GAME_LIMIT}"
  prompt "Press any key to continue"
  gets.chomp

  loop do
    deck = initialize_deck
    dealer_cards = []
    player_cards = []

    initial_card_distribution(deck, dealer_cards, player_cards)

    loop do
      player_hand_value = update_hand_value(player_cards)
      display_board(dealer_cards, dealer_score,
                    player_cards, player_score, hide: true)

      if player_hand_value == GAME_LIMIT
        prompt "PLAYER wins this round!"
        player_score += 1
        break
      elsif player_hand_value > GAME_LIMIT
        prompt "BUST! You are over #{GAME_LIMIT}."
        prompt "DEALER wins this round."
        dealer_score += 1
        break
      end

      choice = player_choice
      if choice == 1
        player_cards = player_cards_update(player_cards, deck)
      elsif choice == 2
        dealer_hand_value = 0
        loop do
          prompt "DEALER's move."
          sleep 1
          dealer_hand_value = update_hand_value(dealer_cards)
          display_board(dealer_cards, dealer_score, player_cards, player_score)
          if dealer_hand_value < DEALER_LIMIT
            dealer_cards = player_cards_update(dealer_cards, deck)
          elsif dealer_hand_value >= DEALER_LIMIT
            break
          end
        end

        display_board(dealer_cards, dealer_score, player_cards, player_score)
        dealer_score, player_score = round_score_update(dealer_hand_value,
                                                        player_hand_value,
                                                        dealer_score,
                                                        player_score)
        break
      end
    end

    if player_score == 5 || dealer_score == 5
      sleep 2
      display_board(dealer_cards, dealer_score, player_cards, player_score)
      prompt "PLAYER WINS THE GAME!" if player_score == 5
      prompt "GAME OVER. DEALER WINS THE GAME!" if dealer_score == 5
      break
    end

    prompt "Press any key to continue"
    gets.chomp
  end

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing #{GAME_LIMIT}! Good Bye!"
