require "./lib/ordered_sequence_formatter"

require "./lib/rules/five_card_draw"
require "./lib/rules/omaha_holdem"
require "./lib/rules/texas_holdem"

class Game
  UnsupportedFormat = Class.new(StandardError)
  PLAYER_TO_CARD_INFO = ->(player) { player.hand.cards.map(&:to_s).join }

  RULES_CODES = {
    "texas-holdem" => Rules::TexasHoldem,
    "omaha-holdem" => Rules::OmahaHoldem,
    "five-card-draw" => Rules::FiveCardDraw
  }

  def initialize(description)
    rule_name, *hands = description
    rules = RULES_CODES.fetch(rule_name) {
      raise UnsupportedFormat.new("Error: Unrecognized game type")
    }
    @players = rules.new(hands).players
  end

  def order
    OrderedSequenceFormatter.new(players.sort).format(&PLAYER_TO_CARD_INFO)
  end

  private

  attr_reader :players
end

def parse_line(line)
  Game.new(line).order.join(" ")
rescue Game::UnsupportedFormat => e
  [e.message]
end

ARGF
  .lazy
  .map { _1.delete("\n") }
  .map { _1.split(" ") }
  .map { parse_line(_1) }
  .each { puts _1 }
