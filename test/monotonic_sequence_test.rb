require "minitest/autorun"

require "./lib/monotonic_sequence"

describe MonotonicSequence do
  using MonotonicSequence

  describe "in case of non-monotonic sequence" do
    it "returns false" do
      refute [1, 10, 100, 1000].monotonic_sequence?
    end
  end

  describe "in case of a monotonic sequence" do
    it "returns true" do
      assert [1, 2, 3, 4, 5].monotonic_sequence?
    end
  end

  describe "in case of an unordered monotonic sequence" do
    it "returns true" do
      assert [1, 2, 3, 4, 5].shuffle.monotonic_sequence?
    end
  end

  describe "with passed step argument" do
    it "returns true for a monotonic sequence" do
      assert [2, 4, 6, 8, 10].monotonic_sequence?(2)
    end

    it "returns false for a monotonic sequence with a different step" do
      refute [2, 4, 6, 8, 10].monotonic_sequence?(3)
    end
  end
end
