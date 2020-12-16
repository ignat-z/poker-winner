require "minitest/autorun"

require "./lib/card"

describe Card do
  subject { Card.new(["5", "c"]) }

  describe "rank" do
    it "returns the rank of a card" do
      assert_equal "5", subject.rank
    end
  end

  describe "suit" do
    it "returns the suit of a card" do
      assert_equal "c", subject.suit
    end
  end

  describe "to_s" do
    it "returns the combined representation of a card" do
      assert_equal "5c", subject.to_s
    end
  end

  describe "cost" do
    it "returns the index of a card in a sequence" do
      assert_equal 3, subject.cost
    end
  end
end
