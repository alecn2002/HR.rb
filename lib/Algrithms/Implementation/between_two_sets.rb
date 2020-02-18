# https://www.hackerrank.com/challenges/between-two-sets/problem

class Primes
  @@primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
  
  def self.get
    @@primes
  end
end

class MultiSet
  attr_reader :multiset
  
  def initialize
    @multiset = {}
    @multiset.default = 0
  end
  
  def add(v, n = 1)
    @multiset[v] += n
    self
  end
  
  alias << add
  
  def set(v, newv = 1)
    if newv > 0 then
      @multiset[v] = newv
    else
      @multiset.delete(v)
    end
    self
  end
  
  def del(v, n = 1)
    set(v, @multiset[v] - n)
  end
  
  def +(other)
    a0 = @multiset.inject(MultiSet.new) {|r, (k, v)|
      r.add(k, v + other[k])
    }
    (other.multiset.keys - @multiset.keys).inject(a0) {|r, (k, v)|
      r.add(k, v)
    }
  end
  
  def -(other)
    @multiset.inject(MultiSet.new) {|r, (k, v)|
      r.add(k, v).del(k, other[k])
    }
  end
  
  def count(k)
    @multiset[k]
  end
  
  alias [] count
  
  def combine(other, fun)
    a0 = @multiset.inject(MultiSet.new) {|r, (k, v)|
      r.set(k, [v, other[k]].send(fun))
    }
    (other.multiset.keys - @multiset.keys).inject(a0) {|r, k|
      r.set(k, [0, other[k]].send(fun))
    }
  end
  
  def empty?
    multiset.empty?
  end
end

module Enumerable
  def inject_with_check(r, check)
    inject(r) {|r1, v|
      return r1 unless check.call(r1, v)
      yield(r1, v)
    }
  end
end

class Array
  def first=(v)
    raise "Attempt to modify first element of empty array" if empty?
    self[0] = v
  end
  
  def last=(v)
    raise "Attempt to modify last element of empty array" if empty?
    self[size-1] = v
  end
  
  def combine(fun)
    self[1...size].inject(first) {|r, v|
      r.combine(v, fun)
    }
  end
  
  def mul
    inject(1) {|r, v| r * v }
  end
end

class Integer
  def split_to_primes
    Primes.get.inject_with_check([MultiSet.new, self], lambda {|r, _| r.last > 1 }) {|r, p|
      while r.last % p == 0 do
        r.first.add(p)
        r.last /= p
#        $stderr.puts "p=#{p} r = #{r}"
      end
      r
    }.first
  end
end

def read_int_line
  readline.strip.split(' ').collect(&:to_i)
end

class BetweenTwoSets
  attr_reader :a, :b
  
  def initialize
    m, n = read_int_line
    @a = read_int_line
    @b = read_int_line
  end
  
  def solve
    return 0 if a.max > b.min
    ac = a.collect(&:split_to_primes).combine(:max)
    bc = b.collect(&:split_to_primes).combine(:min)
    $stderr.puts "ac = #{ac.multiset}\nbc=#{bc.multiset}"
    dif = bc - ac
    $stderr.puts "dif = #{dif.multiset}"
    dif.empty? ? 1 : dif.multiset.values.collect {|v| v + 1 }.mul
  end
end

puts BetweenTwoSets.new.solve
