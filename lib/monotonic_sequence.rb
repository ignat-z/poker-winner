module MonotonicSequence
  refine Array do
    def monotonic_sequence?(step = 1)
      sort.each_cons(2).all? { |(prev_rank, next_rank)| next_rank - prev_rank == step }
    end
  end
end
