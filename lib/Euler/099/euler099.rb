
module Enumerable
  def collectf(f, *args)
    collect {|v| v.send(f, *args) }
  end
end

class Euler099
  attr_reader :a, :hash

  def initialize(lines)
    @a, @hash = lines, lines.each_with_index.inject({}) {|r, (v, idx)|
      v1, v2 = v.split(' ').collectf(:to_i)
      r.update((v2 * Math.log(v1.to_f)) => idx)
      r
    }
  end
  
  def solve(k)
    a[hash[hash.keys.sort[k]]]
  end
end

n = readline.to_i
lines = n.times.collect {|_| readline.strip }
k = readline.to_i - 1

puts Euler099.new(lines).solve(k)
