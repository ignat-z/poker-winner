class ResultVectorsComparator
  EQUAL_VECTOR_FALLBACK = -> { [0, 0] }

  def initialize(vector1, vector2)
    @vector1 = vector1
    @vector2 = vector2
  end

  def compare
    @vector1
      .zip(@vector2)
      .find(EQUAL_VECTOR_FALLBACK) { (_1 <=> _2) != 0 }
      .inject(&:<=>)
  end
end
