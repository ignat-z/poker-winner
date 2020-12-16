module Rules
  class OmahaHoldem
    def initialize(hands)
      @board, *@hands = hands
      @board = @board.chars.each_slice(2).map(&Card.method(:new))
    end

    def players
      @hands.map { Player.new(_1, self) }
    end

    def possible_hands(hand)
      @board.combination(3).to_a
        .product(hand.cards.combination(2).to_a)
        .map(&:flatten).map { Hand.new(_1) }
    end
  end
end
