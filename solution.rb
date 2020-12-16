require "./lib/card"
require "./lib/hand_printer"
require "./lib/hand_values_collection"
require "./lib/ordered_sequence_formatter"
require "./lib/result_vectors_comparator"

require "./lib/rules/five_card_draw"
require "./lib/rules/omaha_holdem"
require "./lib/rules/texas_holdem"

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
    all_costs.max { ResultVectorsComparator.new(_1, _2).compare }
  end

  def all_costs
    HandValuesCollection.for(@cards)
  end

  def <=>(other)
    ResultVectorsComparator.new(cost, other.cost).compare
  end

  private

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
    top_hand <=> other.top_hand
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
