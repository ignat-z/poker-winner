class ResultVectorsComparator
  def initialize(vector1, vector2)
    @vector1 = vector1
    @vector2 = vector2
  end

  def compare
    @vector1
      .zip(@vector2)
      .map { _1 <=> _2 }
      .find(-> { 0 }) { _1 != 0 }
  end
end
