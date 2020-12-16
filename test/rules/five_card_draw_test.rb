require "minitest/autorun"

require "./lib/rules/five_card_draw"

describe Rules::FiveCardDraw do
  subject { Rules::FiveCardDraw.new(hands) }
  let(:hands) do
    [
      "7h4s4h8c9h",
      "Tc5h6dAc5c",
      "Kd9sAs3cQs",
      "Ah9d6s2cKh",
      "4c8h2h6c9c"
    ]
  end
  let(:hand) { Hand.by_description("4c8h2h6c9c") }

  describe "players" do
    it "converts all hands to all players" do
      assert_equal hands.count, subject.players.count
    end
  end

  describe "possible_hands" do
    it "returns only the passed hand" do
      assert_equal [hand], subject.possible_hands(hand)
    end
  end
end
