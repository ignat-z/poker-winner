require "minitest/autorun"

require "./lib/rules/omaha_holdem"

describe Rules::OmahaHoldem do
  subject { Rules::OmahaHoldem.new([board] + hands) }

  let(:board) { "3d3s4d6hJc" }
  let(:hands) do
    [
      "Js2dKd8c",
      "KsAsTcTs",
      "Jh2h3c9c",
      "Qc8dAd6c",
      "7dQsAc5d"
    ]
  end
  let(:hand) { Hand.by_description("Js2dKd8c") }

  describe "players" do
    it "converts all hands to all players" do
      assert_equal hands.count, subject.players.count
    end
  end

  describe "possible_hands" do
    it "returns all combinations for Omaha Hold' em" do
      assert_equal 60, subject.possible_hands(hand).count
    end
  end
end
