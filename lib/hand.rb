require "./lib/card"
require "./lib/hand_printer"
require "./lib/hand_values_collection"
require "./lib/result_vectors_comparator"

class Hand
  include Comparable

  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def self.by_description(description)
    new(description.chars.each_slice(2).map(&Card.method(:new)))
  end

  def cost
    all_costs.max { ResultVectorsComparator.new(_1, _2).compare }
  end

  def <=>(other)
    ResultVectorsComparator.new(cost, other.cost).compare
  end

  def pretty_print
    HandPrinter.new(self).print
  end

  alias_method :inspect, :pretty_print

  private

  def all_costs
    HandValuesCollection.for(@cards)
  end
end
