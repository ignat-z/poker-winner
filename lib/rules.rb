require "./lib/monotonic_sequence"

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
    hand.map(&:cost).sort.reverse
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
