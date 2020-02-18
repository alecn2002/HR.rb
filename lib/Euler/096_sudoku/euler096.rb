require 'set'

module Enumerable
  def collectf(f, *args)
    collect {|v| v.send(f, *args) }
  end
end

def read_n_lines(n)
  n.times.collect {|_| readline }
end

class Array
  def get_column(cid)
    collect {|row| row[cid] }
  end
end

class Set
  def self.non_zero_set(enum)
    Set.new(enum) - Set[0]
  end
end

class String
  def /(n)
    cnt = size / n
    ans = cnt.times.collect {|i| self[i * n ... (i+1) * n]}
    ans << self[cnt * n .. -1] if cnt * n < size
    ans
  end
end

class Euler096
  
  DIM = 9
  SQ_DIM = 3
  
  class Cell
    attr_reader :v, :rid, :cid, :sqid, :old_v, :ids_array
    
    def sq_id(rid, cid)
      (rid / SQ_DIM) * SQ_DIM + cid / SQ_DIM
    end
    
    def initialize(rid, cid, iv)
      @old_v = @v = ((iv == 0) ? Set[*(1..DIM).to_a] : iv)
      @rid, @cid, @sqid = rid, cid, sq_id(rid, cid)
      @ids_array = [rid, cid, sqid]
    end
    
    def changed?
      v != old_v
    end
    
    def update_oldv!
      @old_v = v
    end
    
    def subtract!(other)
      raise "Invalid operation on constant cell @(#{rid}, #{cid}); v=#{v}(#{v.class})" if constant?
      @v -= other
      raise "Empty set as a result of subtraction" if v.empty?
      @v = v.to_a.first if v.size == 1
      self
    end
    
    def constant?
      !v.kind_of?(Set)
    end
  end
  
  class Board
    attr_reader :board, :set_count, :rsets, :csets, :sqsets
    
    def empty_set_array(n)
      n.times.collect {|_| Set[] }
    end
    
    def initialize(a)
      @board = a.collect.with_index {|row, rid| row.strip.split('').collect.with_index {|v, cid| Cell.new(rid, cid, v.to_i) } }.flatten
      @set_count = board.collect {|cell| (cell.constant? ? 0 : 1) }.sum
      @rsets, @csets, @sqsets = board.inject([empty_set_array(DIM), empty_set_array(DIM), empty_set_array(DIM)]) {|r, c|
        c.ids_array.each_with_index {|vid, idx| r[idx][vid] += [c.v] } if c.constant?
        r
      }
      [:board, :set_count, :rsets, :csets, :sqsets].each {|sym| $stderr.puts "#{sym} = #{eval(sym.to_s)}" } # DEBUG
    end
    
    def solve
      prev_set_count = set_count
      while (set_count > 0) do
        $stderr.puts "set_count=#{set_count}" # DEBUG
        sets = [@rsets, @csets, @sqsets]
        board.each {|c|
          unless c.constant? then
            c.ids_array.each_with_index {|vid, idx| c.subtract!(sets[idx][vid]) unless c.constant? }
            if c.changed? && c.constant? then
              c.ids_array.each_with_index {|vid, idx| sets[idx][vid] += [c.v] }
              @set_count -= 1
            end
            c.update_oldv!
          end
        }
        raise "Set count = #{set_count} not changed" if set_count == prev_set_count
        prev_set_count = set_count
      end
      board
    end
  end
  
  attr_reader :board
  
  def initialize(lines)
    @board = Board.new(lines)
  end
  
  def solve
    board.solve.collectf(:v).join('') / DIM
  end
end

puts Euler096.new( read_n_lines(Euler096::DIM) ).solve.join("\n")
