require "minitest/autorun"

require "./lib/result_vectors_comparator"

describe ResultVectorsComparator do
  subject { ResultVectorsComparator.new(vector1, vector2) }

  describe "when the first vector is bigger than the second one" do
    let(:vector1) { [1, 2, 3, 1, 1] }
    let(:vector2) { [1, 2, 2, 5, 5] }

    it "returns 1" do
      assert_equal 1, subject.compare
    end
  end

  describe "when the second vector is bigger than the first one" do
    let(:vector1) { [1, 2, 2, 5, 5] }
    let(:vector2) { [1, 2, 3, 1, 1] }

    it "returns -1" do
      assert_equal -1, subject.compare
    end
  end

  describe "when two vectors have the same values" do
    let(:vector1) { [1, 2, 2, 5, 5] }
    let(:vector2) { vector1 }

    it "returns 0" do
      assert_equal 0, subject.compare
    end
  end
end

