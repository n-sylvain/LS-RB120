52-card deck consisting of the 4 suits (hearts, diamonds, clubs, and spades)
=> 13 values

Try to get as close to 21 as possible without going over. If you go over 21, it's a "bust" and you lose.

2 players: a "dealer" and a "player". Both participants are initially dealt 2 cards.
The player see their 2 cards but can only see one of the dealer's cards

Card values:
2 - 10 face value
jack, queen, king - 10
ace - 1 or 11
=> update_deck_score method

Player turn: the player goes first, and can decide to either "hit or stay".
hit = player ask for another card
if total over 21, the player "busts" and loses
the turn is over when the player either busts or stays. If the player busts, the game is over and the dealer won

Dealer turn: when the player tays, it's the dealer's turn. The dealer must follow a strict rule for hit or stay.
hit until the total is at least 17. If the dealer busts, the player wins

comparing cards: when both the player and the dealer stay, compare the total value of the cards and see who has the
highest value.


1. Initialize deck
2. Deal cards to player and dealer
3. Player turn: hit or stay
  - repeat until bust or "stay"
4. If player bust, dealer wins.
5. Dealer turn: hit or stay
  - repeat until total >= 17
6. If dealer bust, player wins.
7. Compare cards and declare winner.