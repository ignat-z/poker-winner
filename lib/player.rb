require "./lib/hand"

class Player
  include Comparable

  attr_reader :board, :hand, :game

  def initialize(hand, game)
    @hand = Hand.by_description(hand)
    @game = game
  end

  def top_hand
    @_top_hand ||= @game.possible_hands(hand).max
  end

  def <=>(other)
    top_hand <=> other.top_hand
  end
end
