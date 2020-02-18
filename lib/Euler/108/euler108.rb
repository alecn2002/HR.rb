class MultiSet
  attr_reader :multiset
  
  def initialize
    @multiset = {}
    @multiset.default = 0
  end
  
  def add(v)
    @multiset[v] += 1
    self
  end
end

class Primes
  attr_reader :primes
  
  def initialize(up_to)
    @primes = [2, 3, 5, 7, 11]
    ((up_to - 11) / 2).times {|i|
      cur = 13 + i * 2
      @primes << cur if is_prime?(cur)
    }
  end
  
  def is_prime?(n)
    nsqrt = Math.sqrt(n)
    primes.each {|p|
      return true if p > nsqrt
      return false if ((n % p ) == 0)
    }
    return true
  end
  
  def split_to_primes(n)
    primes.inject(MultiSet.new) {|r, p|
      while((n % p) == 0) do
        r.add(p)
        n /= p
      end
      r
    }
  end
end

class Euler108
  attr_reader :primes
  
  def initialize(max_n)
    @primes = Primes.new(max_n)
  end
  
  def solve(n)
    p = primes.split_to_primes(n)
    p.multiset.values.inject(1) {|r, v| r * v } + 1
  end
end

n = readline.to_i
q = n.times.collect {|_| readline.to_i }

solver = Euler108.new(q.max)

q.each {|qv| puts solver.solve(qv) }
