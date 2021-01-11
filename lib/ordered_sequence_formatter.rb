class OrderedSequenceFormatter
  def initialize(list)
    @list = list
  end

  def format(&formatter)
    formatter ||= ->(x) { x.to_s }

    [nil, *@list, nil].each_cons(3).inject([[], []]) { |(result, stack), (before, current, after)|
      iteration = if !stack.empty?
        if !after || current != after

          joined = (stack + [current]).compact.map { |it| formatter.call(it) }.sort.join('=')
          stack = []
          joined
        else
          stack << current
          nil
        end
      elsif after && current == after
        stack << current
        nil
      elsif before && current == before
        nil
      else
        formatter.call(current)
      end

      [result + [iteration], stack]
    }.first.compact
  end
end
