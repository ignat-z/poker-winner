require "minitest/autorun"

require "./lib/rules/texas_holdem"

describe Rules::TexasHoldem do
  subject { Rules::TexasHoldem.new([board] + hands) }

  let(:board) { "3d3s4d6hJc" }
  let(:hands) do
    [
      "Js2d",
      "KsAs",
      "Jh2h",
      "Qc8d",
      "7dQs"
    ]
  end
  let(:hand) { Hand.by_description("Js2d") }

  describe "players" do
    it "converts all hands to all players" do
      assert_equal hands.count, subject.players.count
    end
  end

  describe "possible_hands" do
    it "returns all combinations for Omaha Hold' em" do
      assert_equal 21, subject.possible_hands(hand).count
    end
  end
end
