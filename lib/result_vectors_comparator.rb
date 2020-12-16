class ResultVectorsComparator
  def initialize(vector1, vector2)
    @vector1 = vector1
    @vector2 = vector2
  end

  def compare
    return (@vector1.first <=> @vector2.first) if (@vector1.first <=> @vector2.first) != 0

    non_eqaul = @vector1.drop(1).zip(@vector2.drop(1)).map { _1 <=> _2 }.find { _1 != 0 }
    non_eqaul || 0
  end
end
