
class GFib
  attr_reader :a
  
  def initialize(a, b)
    @a = [a, b]
  end
  
  def nxt
    (@a << a[-2..-1].sum).last
  end
end

class String
  def is_k_pandi?(k)
    ss = split('').sort.uniq
    (ss.size == k) && (ss.first == '1') && (ss.last.to_i == k)
  end
end

class Euler104
  attr_reader :gfib, :k
  
  def initialize(a, b, k)
    @gfib, @k = GFib.new(a, b), k
  end
  
  def solve
    1000000.times {|n|
      nf = gfib.nxt.to_s
      if nf.size >= k then
        return n + 3 if (nf[0...k].is_k_pandi?(k) && nf[-k..-1].is_k_pandi?(k))
      end
    }
    nil
  end
end

a, b, k = 3.times.collect {|_| readline.to_i }

puts Euler104.new(a, b, k).solve
