require 'set'

module Enumerable
  
  def collectf(fun)
    collect {|v| v.send(fun)}
  end
  
end

class Euler075
  attr_reader :squares, :sq_set, :sq_up_to
    
  def initialize(max_n)
    @squares = (0..max_n).collect {|v| v * v }
    @sq_set = Set.new(squares)
    @sq_up_to = (13..max_n).inject([0]*12 + [1]) {|r, n|
      r << r.last + nsq(n)
      r
    }
  end
  
  def nsq(n)
    nsqr = n * n
    nmax = Math.sqrt(nsqr / 3).to_i
    (1 .. nmax).inject(0) {|r, n1|
      nsqr_m_n1sqr = nsqr - n1 * n1 
      (n1+1 .. nmax).inject(r) {|r1, n2|
        r1 += 1 if sq_set.include?(nsqr_m_n1sqr - n2 * n2)
        return 0 if r1 > 1
        r1
      }
    }
  end
  
  def [](n)
    sq_up_to[n]
  end
end

t = readline.to_i
q = (1..t).collect {|_| readline.to_i }

solver = Euler075.new(q.max)

q.each {|qv| puts solver[qv] }
