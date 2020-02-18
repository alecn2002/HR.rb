require 'set'

module Formattable
  def format(f)
    sprintf(f, self)
  end
end

class Integer
  include Formattable
end

# class LinkedSet keeps order of elements insertion.
class LinkedSet
  attr_reader :array, :hash, :set
  
  def initialize
    @array, @hash, @set = [], {}, Set[]
  end
  
  def add(v)
    unless include?(v) then
      @hash.update(v => array.size)
      @array << v
      @set.add(v)
    end
    self
  end
  
  def include?(v)
    set.include?(v)
  end
  
  def index(v)
    hash[v]
  end
  
  def size
    set.size
  end
  
  def [](idx)
    array[idx]
  end
end

module Enumerable
  
  def collectf(f, *args)
    collect {|v| v.send(f, *args) }
  end
end

class String
  def last_n(n)
    return "" if n <= 0
    self[-[n, size].min .. -1]
  end
end

class Integer
  def last_n_digits(n)
    to_s.last_n(n).to_i
  end
end

class Euler097
  
  NDIGITS = 12
  OFORMAT = "%0#{NDIGITS}d"

  attr_reader :a, :b, :c, :d
  
  def initialize
    @a, @b, @c, @d = readline.strip.split(' ').collectf(:to_i)
  end
  
  def repeatable_b_pow_c
    c.times.inject([1, LinkedSet.new]) {|r, v|
#      $stderr.puts "#{v}: #{r.first}; set size=#{r.last.size}" if ((v % 1000) == 0)
      nxt = (r.first * b).last_n_digits(NDIGITS)
      if r.last.include?(nxt) then
        idx = r.last.index(nxt)
        final_idx = idx + (c - v) % (r.last.size - idx)
        return r.last[final_idx]
      end
      [nxt, r.last.add(nxt)]
    }.first.last_n_digits(NDIGITS)
  end
  
  def solve
    bc12 = repeatable_b_pow_c
    (a * bc12 + d).last_n_digits(12)
  end
end

t = readline.to_i
puts (t.collect { Euler097.new.solve }.sum.last_n_digits(Euler097::NDIGITS)).format(Euler097::OFORMAT)
