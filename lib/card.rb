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
