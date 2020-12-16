require "./lib/player"

module Rules
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
end
