module MonotonicSequence
  refine Array do
    def monotonic_sequence?(step = 1)
      sort.each_cons(2).all? { |(prev_rank, next_rank)| next_rank - prev_rank == step }
    end
  end
end

class Rules
  using MonotonicSequence

  NAMES = [
    "ROYAL_FLUSH",
    "STRAIGHT_FLUSH",
    "FOUR_OF_A_KIND",
    "FULL_HOUSE",
    "FLUSH",
    "STRAIGHT",
    "TWO_PAIRS",
    "THREE_OF_A_KIND",
    "PAIR",
    "HIGHCARD"
  ]

  ROYAL_FLUSH = ->(hand) {
    return unless hand.map(&:suit).uniq.one? && hand.map(&:rank).sort == %w[A J K Q T]
    []
  }

  STRAIGHT_FLUSH = ->(hand) {
    return unless hand.map(&:suit).uniq.count == 1 && hand.map(&:cost).monotonic_sequence?
    [hand.map(&:rank).max]
  }

  FOUR_OF_A_KIND = ->(hand) {
    return unless hand.map(&:rank).tally.values.any? {_1 == 4 }
    hand.map(&:cost).tally.sort_by { |(rank, count)| -count }.map(&:first)
  }

  FULL_HOUSE = ->(hand) {
    return unless THREE_OF_A_KIND.call(hand) && PAIR.call(hand)
    hand.map(&:cost).tally.sort_by { |(rank, count)| -count }.map(&:first)
  }

  FLUSH = ->(hand) {
    return unless hand.map(&:suit).uniq.count == 1
    hand.map(&:cost).sort
  }

  STRAIGHT = ->(hand) {
    default_cost = hand.map(&:cost)
    low_ace_cost = hand.map(&:rank).any? { _1 == "A" } ?
      hand.map(&:cost).reject.with_index { |rank, index| index == hand.map(&:rank).index("A") } + [-1] # change only one A to -1
      : default_cost

    return unless [default_cost.monotonic_sequence?, low_ace_cost.monotonic_sequence?].any?
    (default_cost.monotonic_sequence? ? default_cost : low_ace_cost).sort.reverse
  }

  TWO_PAIRS = ->(hand) {
    return unless hand.map(&:rank).tally.values.select { _1 == 2 }.count == 2
    hand.map(&:cost).tally
      .sort_by { |(rank, count)| -count }
      .each_slice(2)
      .flat_map { _1.sort.reverse }
      .map(&:first)
  }

  THREE_OF_A_KIND = ->(hand) {
    return unless hand.map(&:rank).tally.values.one? { _1 == 3 }
    top_cost = hand.map(&:cost).tally.min_by { |(rank, count)| -count }.first
    [top_cost, *hand.map(&:cost).reject { _1 == top_cost }.sort.reverse]
  }

  PAIR = ->(hand) {
    return unless hand.map(&:rank).tally.values.one? { _1 == 2 }
    top_cost = hand.map(&:cost).tally.min_by { |(rank, count)| -count }.first
    [top_cost, *hand.map(&:cost).reject { _1 == top_cost }.sort.reverse]
  }

  HIGHCARD = ->(hand) {
    hand.map(&:cost).sort.reverse
  }

  def self.hand_result(hand)
    [
      ROYAL_FLUSH,
      STRAIGHT_FLUSH,
      FOUR_OF_A_KIND,
      FULL_HOUSE,
      FLUSH,
      STRAIGHT,
      THREE_OF_A_KIND,
      TWO_PAIRS,
      PAIR,
      HIGHCARD
    ].reverse.map.with_index { |checker, priority|
      result = checker.call(hand)
      result ? [priority] + result : nil
    }.compact
  end
end

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

class Card
  RANKS = %w[2 3 4 5 6 7 8 9 T J Q K A]
  SUITS = %w[s h d c]

  def self.rank_value(value)
    RANKS.index(value)
  end

  attr_reader :rank, :suit

  def initialize(description)
    @rank, @suit = description
  end

  def to_s
    [@rank, @suit].join
  end

  def cost
    RANKS.index(@rank)
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
    to_ordered_line(players.sort)
  end

  def to_ordered_line(list)
    [nil, *list, nil].each_cons(3).map { |before, current, after|
      next([current.hand.cards.map(&:to_s).join, after.hand.cards.map(&:to_s).join].join("=")) if (current && after) && current == after
      next(nil) if current && before && current == before
      current.hand.cards.map(&:to_s).join
    }.compact
  end
end

ARGF
  .map { _1.delete("\n") }
  .map { _1.split(" ") }
  .map { Game.new(_1).order }
  .map { puts _1.join(" ") }
