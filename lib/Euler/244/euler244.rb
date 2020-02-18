require 'set'

module HashCalc
  
  def HashCalc.largestNonDivisible(v, *divs)
    until divs.all? {|d| v % d != 0 }
      --v
    end
    v
  end
  
  HASH_INIT = 137
  HASH_MUL = 23
  
  def ==(other)
    self.class == other.class and attrs.all? {|arg| self.send(arg) == other.send(arg)}
  end
  
  alias eql? ==
  
  def hash
    attrs.inject(HASH_INIT) {|r, s| r * HASH_MUL + self.send(s).hash }
  end
  
end

class Point
  ATTRS = [:r, :c]
  attr_reader *ATTRS

  include HashCalc
  
  def attrs 
    ATTRS
  end
  
  def initialize(r, c)
    @r, @c = r, c
  end
end

class Board
  ATTRS = [:white, :reds, :blues]
  attr_reader *ATTRS
  include HashCalc
  
  def attrs 
    ATTRS
  end
  
  def initialize(b)
    @white, @reds, @blues = nil, Set.new, Set.new
    b.each_with_index {|bl, row|
      bl.split('').each_with_index {|c, col|
        p = Point.new(row, col)
        case c
          when 'W' 
            @white = p
          when 'R' 
            @reds << p
          when 'B'
            @blues << p
        end
      }
    }
  end
end

MODULO = 100000007
MUL = 243

class State
  attr_reader :paths
  
  def initialize(path_step, prev_paths)
    @paths = (prev_paths.nil? || prev_paths.empty?) ? Set.new([checksum_step(path_step)]) : Set.new(prev_paths.collect {|pp| checksum_step(path_step, pp) })
  end
  
  def checksum_step(c, prev = 0)
    (prev * MUL + c.ord) % MODULO
  end
  
  def add_path(path_step, prev_paths)
    prev_paths.each {|pp| @paths.add(checksum_step(path_step, pp))}
  end
end

class Euler244
  
  attr_reader :initial, :expected
  
  def initialize(initial, expected)
    @initial, @expected = *([initial, expected].collect {|bs| Board.new(bs)})
  end
  
  def sum_checksums(sa)
     sa.sum % MODULO
  end
  
  def step(current)
    
  end
  
  def solve
    used_set = Set.new
    used_set.add(initial)
    
    cur = {initial => State.new(0, nil)}
    
    reached = false
    until reached do
      nxt = cur.inject({}) {|r, (b, s)|
        
      }
      
    end
  end
end
