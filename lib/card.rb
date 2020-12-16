class Card
  RANKS = %w[2 3 4 5 6 7 8 9 T J Q K A]
  SUITS = %w[s h d c]

  attr_reader :rank, :suit

  def initialize(description)
    @rank, @suit = description
  end

  def to_s
    [@rank, @suit].join
  end

  def cost
    @_cost ||= RANKS.index(@rank)
  end
end
