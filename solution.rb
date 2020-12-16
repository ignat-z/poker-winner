require "./lib/ordered_sequence_formatter"

require "./lib/rules/five_card_draw"
require "./lib/rules/omaha_holdem"
require "./lib/rules/texas_holdem"

class Game
  UnsupportedFormat = Class.new(StandardError)

  RULES_CODES = {
    "texas-holdem" => Rules::TexasHoldem,
    "omaha-holdem" => Rules::OmahaHoldem,
    "five-card-draw" => Rules::FiveCardDraw
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
