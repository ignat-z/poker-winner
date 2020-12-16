require "minitest/autorun"

require "./lib/hand"

describe Hand do
  subject { Hand.new(cards) }

  let(:cards) { (4..8).map { Card.new([_1.to_s, "c"]) } }

  describe "by_description" do
    it "allows to create hand from the passed hand description" do
      assert_equal(
        cards.map(&:to_s),
        Hand.by_description("4c5c6c7c8c").cards.map(&:to_s)
      )
    end
  end

  describe "cost" do
    let(:all_costs) { [[1, 2, 3], [2, 3]] }

    it "returns max possible costs of a card" do
      HandValuesCollection.stub(:for, all_costs) do
        assert_equal [2, 3], subject.cost
      end
    end
  end

  describe "<=>" do
    let(:all_costs) { [[1, 2, 3], [2, 3]] }

    it "allows to compare two hands" do
      HandValuesCollection.stub(:for, all_costs) do
        assert subject == Hand.by_description("4c5c6c7c8c")
      end
    end
  end
end
