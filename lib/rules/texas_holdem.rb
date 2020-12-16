module Rules
  class TexasHoldem
    def initialize(hands)
      @board, *@hands = hands
      @board = @board.chars.each_slice(2).map(&Card.method(:new))
    end

    def players
      @hands.map { Player.new(_1, self) }
    end

    def possible_hands(hand)
      (@board + hand.cards).combination(5).to_a.map { Hand.new(_1) }
    end
  end
end
