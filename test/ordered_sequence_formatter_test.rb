require "minitest/autorun"

require "./lib/ordered_sequence_formatter"

describe OrderedSequenceFormatter do
  subject { OrderedSequenceFormatter.new(list) }

  describe "with an ordered list without duplicates" do
    let(:list) { [1, 2, 3, 4, 5] }

    it "shows it as is" do
      assert_equal %w[1 2 3 4 5], subject.format
    end
  end

  describe "with an ordered list with duplicates" do
    let(:list) { [1, 2, 3, 3, 5] }

    it "combines them into one expression" do
      assert_equal %w[1 2 3=3 5], subject.format
    end
  end

  describe "with passed formatter" do
    let(:list) { [1, 2, 3, 4, 5] }
    let(:formatter) { ->(i) { ('A'..'Z').to_a[i] } }

    it "applies it to each value" do
      assert_equal %w[B C D E F], subject.format(&formatter)
    end
  end

  describe "in case of the same values but different formats" do
    MyNumber = Struct.new(:value, :name) do
      include Comparable

      def <=>(number2)
        value <=> number2.value
      end
    end

    let(:list) do
      [
        MyNumber.new(1, 'one'),
        MyNumber.new(2, 'two'),
        MyNumber.new(2, 'dos')
      ]
    end
    let(:formatter) { ->(i) { i.name } }

    it "sorts them alphabetically" do
      assert_equal %w[one dos=two], subject.format(&formatter)
    end
  end
end

