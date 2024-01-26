require 'pry'
require 'yaml'
MESSAGES = YAML.load_file('rsp_bonus.yml')

CHOICES = {
  rock: { abbreviation: :r, beats: [:lizard, :scissors] },
  paper: { abbreviation: :p, beats: [:rock, :spock] },
  scissors: { abbreviation: :sc, beats: [:paper, :lizard] },
  spock: { abbreviation: :sp, beats: [:scissors, :rock] },
  lizard: { abbreviation: :l, beats: [:spock, :paper] }
}

def prompt(message)
  Kernel.puts("=> #{message}")
end

def messages(message)
  MESSAGES[message]
end

def determine_winner(player, player_score, computer, computer_score)
  if player == computer
    return player_score, computer_score, messages('game_tie')
  elsif CHOICES[player][:beats].include?(computer)
    return player_score + 1, computer_score, messages('game_player_win')
  else
    return player_score, computer_score + 1, messages('game_computer_win')
  end
end

prompt(messages('welcome'))
prompt(messages('rules'))

choice = ''
player_score = 0
computer_score = 0
round_number = 0

while player_score < 3 && computer_score < 3
  round_number += 1
  loop do
    puts ""
    prompt(messages('player_choice_request'))
    CHOICES.each do |value, set|
      prompt("- #{value} (or #{set[:abbreviation]})")
    end
    choice = Kernel.gets().chomp().downcase().to_sym()

    if CHOICES.key?(choice) ||
       CHOICES.any? { |_, diminutive| diminutive[:abbreviation] == choice }
      if CHOICES.any? { |_, diminutive| diminutive[:abbreviation] == choice }
        choice = CHOICES.find { |_, value| value[:abbreviation] == choice }[0]
      end
      break
    else
      prompt(messages('player_choice_try_again'))
    end
  end

  computer_choice = CHOICES.keys.sample

  message = messages('player_choice_selection') + choice.to_s + ' - ' +
            messages('computer_choice_selection') + computer_choice.to_s
  prompt(message)

  player_score,
  computer_score, display_results = determine_winner(choice, player_score,
                                                     computer_choice,
                                                     computer_score)
  prompt(display_results)

  message = "[#{messages('player_name')}#{player_score}:"
  message = "#{message}#{computer_score}#{messages('computer_name')}]"
  prompt("#{messages('round')}#{round_number} : #{message}")

  if player_score == 3
    prompt(messages('player_win'))
  elsif computer_score == 3
    prompt(messages('computer_win'))
  end
end

prompt(messages('end_game'))
