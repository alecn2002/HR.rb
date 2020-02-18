module Enumerable
  
  def collectf(fun)
    collect {|v| v.send(fun)}
  end
  
end

class Euler067
  
  attr_reader :triangle
  
  def initialize
    n = readline.to_i
    @triangle = (0...n).collect {|ln|
      readline.strip.split(' ').collectf(:to_i)
    }
  end
  
  def dump_line(t, l)
    $stderr.puts "#{t}: [#{l.join(' ')}]"
  end
  
  def solve
    triangle[1..-1].inject(triangle.first) {|r, l|
      l.collect.with_index {|v, i|
        v + r[[0, i-1].max .. [i, r.size-1].min].max
      }
    }.max
  end
end

t = readline.to_i

t.times {
  solver = Euler067.new
  puts solver.solve
}
