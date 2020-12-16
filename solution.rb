require "./lib/rules"
require "./lib/card"
require "./lib/ordered_sequence_formatter"
require "./lib/hand_printer"

class TexasHoldem
  def initialize(hands)
    @board, *@hands = hands
    @board = @board.chars.each_slice(2).map(&Card.method(:new))
  end

  def players
    @hands.map { Player.new(_1, self) }
  end

  def possible_hands(hand)
    (@board + hand.cards).combination(5).to_a.map { Hand.new(_1) }
  end
end

class OmahaHoldem
  def initialize(hands)
    @board, *@hands = hands
    @board = @board.chars.each_slice(2).map(&Card.method(:new))
  end

  def players
    @hands.map { Player.new(_1, self) }
  end

  def possible_hands(hand)
    @board.combination(3).to_a
      .product(hand.cards.combination(2).to_a)
      .map(&:flatten).map { Hand.new(_1) }
  end
end

class FiveCardDraw
  def initialize(hands)
    @hands = hands
  end

  def players
    @hands.map { Player.new(_1, self) }
  end

  def possible_hands(hand)
    [hand]
  end
end

class Hand
  include Comparable

  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def self.by_description(description)
    new(description.chars.each_slice(2).map(&Card.method(:new)))
  end

  def cost
    all_costs.max { cost_compare(_1, _2) }
  end

  def all_costs
    Rules.hand_result(@cards)
  end

  def <=>(other)
    cost1 = cost
    cost2 = other.cost

    cost_compare(cost1, cost2)
  end

  private

  def cost_compare(cost1, cost2)
    return cost1.first <=> cost2.first if (cost1.first <=> cost2.first) != 0

    non_eqaul = cost1.drop(1).zip(cost2.drop(1)).map { _1 <=> _2 }.find { _1 != 0 }
    non_eqaul || 0
  end

  def pretty_print
    HandPrinter.new(self).print
  end
  alias_method :inspect, :pretty_print
end

class Player
  include Comparable

  attr_reader :board, :hand, :game

  def initialize(hand, game)
    @hand = Hand.by_description(hand)
    @game = game
  end

  def top_hand
    @game.possible_hands(hand).max
  end

  def <=>(other)
    cost1 = top_hand
    cost2 = other.top_hand

    cost1 <=> cost2
  end
end

class Game
  UnsupportedFormat = Class.new(StandardError)

  RULES_CODES = {
    "texas-holdem" => TexasHoldem,
    "omaha-holdem" => OmahaHoldem,
    "five-card-draw" => FiveCardDraw
  }

  attr_reader :players, :rules

  def initialize(description)
    rule_name, *hands = description
    @rules = RULES_CODES.fetch(rule_name) {
      raise UnsupportedFormat.new("Error: Unrecognized game type")
    }
    @players = @rules.new(hands).players
  end

  def order
    OrderedSequenceFormatter.new(players.sort).format { |player|
      player.hand.cards.map(&:to_s).join
    }
  end
end

def parse_line(line)
  Game.new(line).order.join(" ")
rescue Game::UnsupportedFormat => e
  [e.message]
end

ARGF
  .map { _1.delete("\n") }
  .map { _1.split(" ") }
  .map { parse_line(_1) }
  .each { puts _1 }
