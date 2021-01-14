require "minitest/autorun"

require "./lib/hand_values_collection"

describe HandValuesCollection do
  describe "ROYAL_FLUSH" do
    it "returns nil for not a royal flush" do
      assert_nil HandValuesCollection::ROYAL_FLUSH.call(cards("2c3c4c5c6c"))
    end

    it "returns empty array for a royal flush" do
      assert_equal(
        [],
        HandValuesCollection::ROYAL_FLUSH.call(cards("TcAcQcJcKc"))
      )
    end
  end

  describe "STRAIGHT_FLUSH" do
    it "returns nil for not a STRAIGHT flush" do
      assert_nil HandValuesCollection::STRAIGHT_FLUSH.call(cards("2c3c4c5c6d"))
    end

    it "returns the top cart if a straight flush" do
      assert_equal(
        [3, 2, 1, 0, -1],
        HandValuesCollection::STRAIGHT_FLUSH.call(cards("3h4h5h2hAh"))
      )
    end
  end

  describe "FOUR_OF_A_KIND" do
    it "returns nil for not a FOUR_OF_A_KIND flush" do
      assert_nil HandValuesCollection::FOUR_OF_A_KIND.call(cards("2c2d2s3h6d"))
    end

    it "returns the top card and the rest one for a FOUR_OF_A_KIND flush" do
      assert_equal(
        [0, 4],
        HandValuesCollection::FOUR_OF_A_KIND.call(cards("2c2d2s2h6d"))
      )
    end
  end

  describe "FULL_HOUSE" do
    it "returns nil for not a full house" do
      assert_nil HandValuesCollection::FULL_HOUSE.call(cards("2c2d2s3h6d"))
    end

    it "returns rank of three and pair cards of a full house" do
      assert_equal(
        [0, 1],
        HandValuesCollection::FULL_HOUSE.call(cards("2c2d2s3h3d"))
      )
    end
  end

  describe "FLUSH" do
    it "returns nil for not a flush" do
      assert_nil HandValuesCollection::FLUSH.call(cards("2c2d2s3h6d"))
    end

    it "returns ordered ranks of a flush" do
      assert_equal(
        [12, 7, 4, 3, 1],
        HandValuesCollection::FLUSH.call(cards("9c3c6cAc5c"))
      )
    end
  end

  describe "STRAIGHT" do
    it "returns nil for not a straight" do
      assert_nil HandValuesCollection::STRAIGHT.call(cards("2c2d2s3h6d"))
    end

    it "returns ordered ranks of a straight with a high ace" do
      assert_equal(
        [12, 11, 10, 9, 8],
        HandValuesCollection::STRAIGHT.call(cards("TsJcQdKhAc"))
      )
    end

    it "returns ordered ranks of a straight with a low ace" do
      assert_equal(
        [3, 2, 1, 0, -1],
        HandValuesCollection::STRAIGHT.call(cards("2c3c4c5cAd"))
      )
    end
  end

  describe "TWO_PAIRS" do
    it "returns nil for not a two pairs" do
      assert_nil HandValuesCollection::TWO_PAIRS.call(cards("2c2d2s3h6d"))
    end

    it "returns ordered pairs ranks of a two pairs" do
      assert_equal(
        [2, 0, 12],
        HandValuesCollection::TWO_PAIRS.call(cards("2c2c4c4cAd"))
      )
    end
  end

  describe "THREE_OF_A_KIND" do
    it "returns nil for not a three pairs" do
      assert_nil HandValuesCollection::THREE_OF_A_KIND.call(cards("2c2d4s3h6d"))
    end

    it "returns rank of three of a kind and all other cars in order" do
      assert_equal(
        [0, 12, 2],
        HandValuesCollection::THREE_OF_A_KIND.call(cards("2d2c2hAd4c"))
      )
    end
  end

  describe "PAIR" do
    it "returns nil for not a pair" do
      assert_nil HandValuesCollection::PAIR.call(cards("2c3d4s5h6d"))
    end

    it "returns rank of a pair and all other cars in order" do
      assert_equal(
        [0, 12, 2, 1],
        HandValuesCollection::PAIR.call(cards("2d2c3hAd4c"))
      )
    end
  end

  describe "HIGHCARD" do
    it "returns all cards ordered by rank" do
      assert_equal(
        [4, 3, 2, 1, 0],
        HandValuesCollection::HIGHCARD.call(cards("2c3d4s5h6d"))
      )
    end
  end

  describe "for" do
    it "calculates the first possible ranks for passed card" do
      assert_equal(
        [9], # ROYAL_FLUSH
        HandValuesCollection.for(cards("TcAcQcJcKc"))
      )
    end
  end

  private

  def cards(line)
    Hand.by_description(line).cards
  end
end
