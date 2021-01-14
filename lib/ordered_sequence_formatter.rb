class OrderedSequenceFormatter
  DEFAULT_FORMATTER = ->(x) { x.to_s }

  def initialize(list)
    @list = list
  end

  def format(&formatter)
    formatter ||= DEFAULT_FORMATTER

    [nil, *@list, nil].each_cons(3).inject([[], []]) { |(result, stack), (before, current, after)|
      if !stack.empty? && (!after || current != after)
        joined = (stack + [current]).map { |it| formatter.call(it) }.sort.join('=')
        [result + [joined], []]
      elsif !stack.empty? || after && current == after
        [result, stack + [current]]
      elsif before && current == before
        [result, stack]
      else
        [result + [formatter.call(current)], stack]
      end
    }.first
  end
end
