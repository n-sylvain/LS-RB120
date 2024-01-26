# require 'pry'
require 'yaml'
MESSAGES = YAML.load_file('rsp_bonus.yml')

VALID_CHOICES = { rock: [:lizard, :scissors],
                  paper: [:rock, :spock],
                  scissors: [:paper, :lizard],
                  spock: [:scissors, :rock],
                  lizard: [:spock, :paper] }

PLAYER_CHOICES = { r: :rock,
                   p: :paper,
                   sc: :scissors,
                   sp: :spock,
                   l: :lizard }

def prompt(message)
  Kernel.puts("=> #{message}")
end

def messages(message)
  MESSAGES[message]
end

def display_results(player, computer)
  if player == computer
    prompt("It's a tie!")
  elsif VALID_CHOICES[player].include?(computer)
    prompt('You won this round!')
  else
    prompt('You lost this round!')
  end
end

def update_score(player, player_score, computer, computer_score)
  if player == computer
    return player_score, computer_score
  elsif VALID_CHOICES[player].include?(computer)
    return player_score + 1, computer_score
  else
    return player_score, computer_score + 1
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
    prompt("#{messages('round')}#{round_number}")
    prompt(messages('player_choice_request'))
    PLAYER_CHOICES.each do |diminutive, value|
      prompt("- #{value} (or #{diminutive})")
    end
    choice = Kernel.gets().chomp().downcase().to_sym()

    if PLAYER_CHOICES.key?(choice) || PLAYER_CHOICES.value?(choice)
      choice = PLAYER_CHOICES[choice] if PLAYER_CHOICES.key?(choice)
      prompt("#{messages('player_choice_selection')}#{choice}")
      prompt(messages('player_choice_validation'))
      break if Kernel.gets().chomp().downcase().start_with?('y')
    else
      prompt(messages('player_choice_try_again'))
    end
  end

  computer_choice = VALID_CHOICES.keys.sample

  message = "#{messages('player_choice_selection')}#{choice}; "
  message = "#{message}#{messages('computer_choice_selection')}#{computer_choice}"
  prompt(message)

  display_results(choice, computer_choice)
  player_score, computer_score = update_score(choice, player_score,
                                              computer_choice, computer_score)

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
