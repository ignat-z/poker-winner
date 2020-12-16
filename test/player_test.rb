require "minitest/autorun"

require "./lib/player"

describe Player do
  subject { Player.new(hand, game) }

  describe "top_hand" do
    let(:game) { Minitest::Mock.new }
    let(:hand) { "2c3c" }
    let(:hand_parsed) { Hand.by_description("2c3c") }

    let(:low_hand) { Hand.by_description("2c3d4c5c6c") }
    let(:hight_hand) { Hand.by_description("3c4d5c6c7c") }

    it "returns the top possible hand on this player" do
      game.expect(:possible_hands, [low_hand, hight_hand], [hand_parsed])

      assert_equal hight_hand, subject.top_hand
      assert_mock game
    end
  end
end
