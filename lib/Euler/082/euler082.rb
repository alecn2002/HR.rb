class Point
  attr_reader :row, :col
  
  def initialize(row, col)
    @row, @col = row, col
  end
  
  def next_row
    Point.new(row+1, col)
  end
  
  def next_col
    Point.new(row, col+1)
  end
  
  def prev_row
    Point.new(row-1, col)
  end
  
  def to_s
    "(#{[row, col].join(', ')})"
  end
end

class Hash
  def update_with_min(k, v)
    cond = (!has_key?(k) || v < self[k])
    update(k => v) if cond
    return cond
  end
end

class Matrix
  
  class Factory
    def self.with_dimensions(rows, cols)
      Matrix.new(Point.new(rows, cols)).dump("Factory.with_dimensions")
    end
    
    def self.with_matrix(m)
      Matrix.new(m).dump("Factory.with_matrix")
    end
    
    def self.with_first_column(column, cols)
      m = Matrix::Factory.with_dimensions(column.size, cols)
      column.each.with_index {|v, idx| m.matrix[idx][0] = v}
      m.dump("Factory.with_first_column")
    end
  end

  attr_reader :matrix
  
  def dump(name)
#    $stderr.puts "#{name} created: #{matrix.collect {|r| "[#{r.join(', ')}]"}.join("\n")}" # DEBUG
    self
  end
  
  def initialize(inp)
    @matrix = case inp
    when Point
#      $stderr.puts "Input is Point" # DEBUG
      (0...inp.row).collect {|_| [nil] * inp.col}
    when Matrix, Array
#      $stderr.puts "Input is #{inp.class.to_s}" # DEBUG
      (inp.instance_of?(Array) ? inp : inp.matrix).dup
    else
      $stderr.puts "Unsupported input type #{inp.class.to_s}"
    end
    dump("Matrix.new")
  end
  
  def [](p)
    matrix[p.row][p.col]
  end
  
  def []=(p, v)
    matrix[p.row][p.col] = v
  end
  
  def update_with_min(p, v)
#    $stderr.puts "Matrix::update_with_min(#{p}, #{v}) self[p] = (#{self[p].class})#{self[p]}"  # DEBUG
    cond = (self[p].nil? ? true : (v < self[p]))
    self[p] = v if cond
    cond
  end
  
  def size
    matrix.size
  end
  
  def first
    matrix.first
  end
  
  def get_column(c)
    matrix.collect {|row| row[c]}
  end
  
  def get_last_column
    get_column(matrix.first.size - 1)
  end
end

class Numeric
  def between(l, u)
    (l <= self) && (self < u)
  end
end

class Euler082
  attr_reader :matrix, :rows, :cols
  
  def initialize
    n = readline.strip.to_i
    @matrix = Matrix.new((0...n).collect {|_|
      readline.strip.split(' ').collect {|l| l.to_i }
    })
    @rows, @cols = matrix.size, matrix.first.size
  end
  
  def valid_rc?(rc)
    [[rc.row, rows], [rc.col, cols]].all? {|xu| xu.first.between(0, xu.last) }
  end
  
  def update(res, rc, oldv)
    valid_rc?(rc) ? res.update_with_min(rc, oldv + matrix[rc]) : false
  end
  
  def do_updates(final, res, rc, v)
    update(res, rc, v) if update(final, rc, v)
  end
  
  def solve
    cur = matrix.get_column(0).each_with_index.inject({}) {|res, v_idx|
      v, idx = v_idx
      res.update(Point.new(idx, 0) => v) 
    }
    final = Matrix::Factory.with_first_column(matrix.get_column(0), matrix.first.size)
    while (!cur.empty?) do
#      $stderr.puts "cur=#{cur}"
      cur = cur.inject({}) {|res, rcv|
        rc, v = rcv.first, rcv.last
        [rc.prev_row, rc.next_row, rc.next_col].each {|cur_rc|
          update(res, cur_rc, v) if update(final, cur_rc, v)
        }
        res
      }
    end
    final.get_last_column.min
  end
end

puts Euler082.new.solve
