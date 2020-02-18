require 'set'

module Enumerable
  def collectf(f, *args)
    collect {|v| v.send(f, *args) }
  end
end

class Set
  def delete_elem(e)
    dup.delete(e)
  end
end

class Array
  def last_contiguous
    return nil if empty?
    return first if size == 1
    self[1..-1].inject(first) {|r, v| 
      (v == r+1) ? v : r
    }
  end
end

class Euler093
  
  attr_reader :m, :s
  
  def initialize
    @m = readline.to_i
    @s = Set.new(readline.strip.split(' ').collectf(:to_r))
#    $stderr.puts "m=#{m} s=#{s}"
  end
  
  def gen_initial
    ans = s.inject({}) {|r, se| r.update(s.delete_elem(se) => Set.new([se])) }
#    $stderr.puts "gen_initial = #{ans}"
    ans
  end
  
  def gen_next(r, k, vs)
#    $stderr.puts "gen_next(r=#{r}, k=#{k}, vs=#{vs})"
    k.each {|v|
      new_set = k.delete_elem(v)
      r.update(new_set => []) unless r.has_key?(new_set)
      vs.each {|next_v|
        r[new_set] += [v + next_v, v - next_v, next_v - v, v * next_v, v / next_v, next_v / v].delete_if {|v| v.zero? }
      }
    }
    r
  end
  
  def solve
    ans = (1 ... s.size).inject(gen_initial) {|r, _|
      r.inject({}) {|rr, kv| gen_next(rr, kv.first, kv.last) }
    }.values.flatten.delete_if {|rv| (rv.negative? || (rv.denominator != 1)) }.collectf(:to_i).sort
    return 0 if ans.empty?
    return 0 if (ans.first != 1)
    ans.last_contiguous
  end
end

puts Euler093.new.solve
