require "minitest/autorun"

require "./lib/hand_printer"

describe HandPrinter do
  subject { HandPrinter.new(Hand.new(cards)) }

  let(:cards) { (4..8).map { Card.new([_1.to_s, "c"]) } }

  describe "print" do
    it "provides a detailed representation of a hand" do
      assert_equal(
        "Hand[4c5c6c7c8c -> STRAIGHT_FLUSH]",
        subject.print
      )
    end
  end
end
