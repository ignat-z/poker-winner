require './lib/rules'
require './lib/card'
require './lib/ordered_sequence_formatter'

class TexasHoldem; end

class OmahaHoldem; end

class FiveCardDraw; end

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

  def cost_compare(cost1, cost2)
    return cost1.first <=> cost2.first if (cost1.first <=> cost2.first) != 0

    non_eqaul = cost1.drop(1).zip(cost2.drop(1)).map { _1 <=> _2 }.find { _1 != 0 }
    non_eqaul || 0
  end

  def pp
    desc = "Hand[#{cards.map(&:to_s).join(" ")}"
    desc += if cards.length == 5
      " -- #{Rules::NAMES.reverse[cost.first]}]"
    else
      "]"
    end

    desc
  end
  alias_method :inspect, :pp
end

class Player
  include Comparable

  attr_reader :board, :hand

  def initialize(hand, board)
    @hand = Hand.by_description(hand)
    @board = board
  end

  def top_hand
    possible_hands.max
  end

  def possible_hands
    (board + hand.cards).combination(5).to_a.map { Hand.new(_1) }
  end

  def <=>(other)
    cost1 = top_hand
    cost2 = other.top_hand

    cost1 <=> cost2
  end
end

class Game
  RULES_CODES = {
    "texas-holdem" => TexasHoldem,
    "omaha-holdem" => OmahaHoldem,
    "five-card-draw" => FiveCardDraw
  }

  attr_reader :board, :players, :rules

  def initialize(description)
    rule_name, board, *hands = description
    @rules = RULES_CODES.fetch(rule_name)
    @board = board.chars.each_slice(2).map(&Card.method(:new))
    @players = hands.map { Player.new(_1, @board) }
  end

  def order
    return [] unless rules == TexasHoldem
    OrderedSequenceFormatter.new(players.sort).format { |player|
      player.hand.cards.map(&:to_s).join
    }
  end
end

ARGF
  .map { _1.delete("\n") }
  .map { _1.split(" ") }
  .map { Game.new(_1).order }
  .map { puts _1.join(" ") }
