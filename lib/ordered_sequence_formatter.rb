class OrderedSequenceFormatter
  def initialize(list)
    @list = list
  end

  def format(&formatter)
    formatter ||= ->(x) { x.to_s }

    [nil, *@list, nil].each_cons(3).map { |before, current, after|
      next([formatter.call(current), formatter.call(after)].sort.join("=")) if after && current == after
      next(nil) if before && current == before
      formatter.call(current)
    }.compact
  end
end
