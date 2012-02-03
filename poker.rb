require 'ostruct'

module Person
  attr_accessor :name, :hand
end

class StateError < StandardError
end

class Game
  attr_accessor :deck, :dealer, :players

  def initialize
    @dealer = Dealer.new(self)
    @players = (1..5).map { Player.new game: self }
    dealer.start
  end

  def restart
    [@dealer, @players].flatten.each { |person| person.hand = [] }
    dealer.start
  end
end

class Dealer
  include Person

  attr_accessor :decks, :game

  def initialize(game)
    @game = game
    @decks = (1..3).map { Deck.new(self) }
  end

  def open_deck
    if decks.any?
      decks.pop
    else
      raise StateError
    end
  end

  def start
    game.deck = open_deck
    game.deck.shuffle
    game.players.each do |player|
      hand = (1..7).map { game.deck.cards.pop }
      deal player, hand
    end
  end

  def deal(player, draw)
    player.hand = draw
  end
end

class Deck
  TYPES = %w[club heart spade diamond].map(&:to_sym)
  VALUES = %w[1 2 3 4 5 6 7 8 9 10 11 12 13].map(&:to_i)

  attr_accessor :cards, :dealer

  def initialize(dealer)
    @dealer = dealer
    @cards = []
    for type in TYPES
      for value in VALUES
        @cards << Card.new(type: type, value: value, holder: self)
      end
    end
  end

  def shuffle
    cards.shuffle!
  end

  def size
    cards.size
  end

end

class Player < OpenStruct
  def play(index)
    hand[index]
  end
end

class Card < OpenStruct
  def name
    case value
      when 1 then "Ace"
      when 2 then "Two"
      when 3 then "Three"
      when 4 then "Four"
      when 5 then "Five"
      when 6 then "Six"
      when 7 then "Seven"
      when 8 then "Eight"
      when 9 then "Nine"
      when 10 then "Ten"
      when 11 then "Jack"
      when 12 then "Queen"
      when 13 then "King"
    end
  end

  def to_s
    "#{name} of #{type}s"
  end
end

game = Game.new
game.players.each do |player|
  puts player
  puts player.hand.map(&:to_s).join ", "
end
