require "./lib/monotonic_sequence"

class HandValuesCollection
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

  ROYAL_RANKS = %w[A J K Q T].freeze
  HIGH_ACE_RANK = 12
  LOW_ACE_RANK = -1
  COUNT_DESC = -> (description) { -description.last }

  ROYAL_FLUSH = ->(hand) {
    return unless hand.uniq(&:suit).one? && hand.map(&:rank).sort == ROYAL_RANKS
    []
  }

  STRAIGHT_FLUSH = ->(hand) {
    return unless hand.uniq(&:suit).one? && hand.map(&:cost).monotonic_sequence?
    [hand.map(&:cost).max]
  }

  FOUR_OF_A_KIND = ->(hand) {
    return unless hand.map(&:rank).tally.values.any? { _1 == 4 }
    hand.map(&:cost).tally.sort_by(&COUNT_DESC).map(&:first)
  }

  FULL_HOUSE = ->(hand) {
    return unless THREE_OF_A_KIND.call(hand) && PAIR.call(hand)
    hand.map(&:cost).tally.sort_by(&COUNT_DESC).map(&:first)
  }

  FLUSH = ->(hand) {
    return unless hand.uniq(&:suit).one?
    hand.map(&:cost).sort.reverse
  }

  STRAIGHT = ->(hand) {
    default_cost = hand.map(&:cost)
    low_ace_cost = default_cost.any? { _1 == HIGH_ACE_RANK } ?
      default_cost.reject.with_index { |rank, index| index == default_cost.index(HIGH_ACE_RANK) } + [LOW_ACE_RANK] # change only one A to -1
      : default_cost

    return if !default_cost.monotonic_sequence? && !low_ace_cost.monotonic_sequence?
    (default_cost.monotonic_sequence? ? default_cost : low_ace_cost).sort.reverse
  }

  TWO_PAIRS = ->(hand) {
    return unless hand.map(&:rank).tally.values.count { _1 == 2 } == 2
    hand.map(&:cost).tally
      .sort_by(&COUNT_DESC)
      .each_slice(2)
      .flat_map { _1.sort.reverse }
      .map(&:first)
  }

  THREE_OF_A_KIND = ->(hand) {
    return unless hand.map(&:rank).tally.values.one? { _1 == 3 }
    top_cost = hand.map(&:cost).tally.max_by(&:last).first
    [top_cost, *hand.map(&:cost).reject { _1 == top_cost }.sort.reverse]
  }

  PAIR = ->(hand) {
    return unless hand.map(&:rank).tally.values.one? { _1 == 2 }
    top_cost = hand.map(&:cost).tally.max_by(&:last).first
    [top_cost, *hand.map(&:cost).reject { _1 == top_cost }.sort.reverse]
  }

  HIGHCARD = ->(hand) {
    hand.map(&:cost).sort.reverse
  }

  RULES = [
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
  ].freeze

  def self.for(hand)
    RULES.each_with_index { |checker, priority|
      result = checker.call(hand)
      break([NAMES.length - priority - 1] + result) if result
    }
  end
end
