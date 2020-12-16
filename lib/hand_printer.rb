class HandPrinter
  def initialize(hand)
    @hand = hand
  end

  def print
    [
      "Hand[",
      @hand.cards.map(&:to_s).join,
      (" -> #{Rules::NAMES.reverse[@hand.cost.first]}" if @hand.cards.length == 5),
      "]"
    ].join
  end
end
