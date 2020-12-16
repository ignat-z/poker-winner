require "./lib/hand_values_collection"

class HandPrinter
  def initialize(hand)
    @hand = hand
  end

  def print
    [
      "Hand[",
      @hand.cards.map(&:to_s).join,
      (" -> #{HandValuesCollection::NAMES.reverse[@hand.cost.first]}" if @hand.cards.length == 5),
      "]"
    ].join
  end
end
