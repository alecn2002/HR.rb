class Hash
  def update_with_min(k, v)
    update(k => [self[k], v].compact.min)
  end
end


class Euler081
  attr_reader :matrix, :rows, :cols
  
  def initialize
    n = readline.strip.to_i
    @matrix = (0...n).collect {|_|
      readline.strip.split(' ').collect {|l| l.to_i }
    }
    @rows, @cols = matrix.size, matrix.first.size
  end
  
  def update(res, r, c, oldv)
    res.update_with_min([r, c], oldv + matrix[r][c]) if ((r < rows) && (c < cols))
    res
  end
  
  def solve
    num = rows + cols - 2
    (0 ... num).inject({[0, 0] => matrix.first.first}) {|r, _|
      r.inject({}) {|rr, v|
        update(rr, v.first.first, v.first.last + 1, v.last)
        update(rr, v.first.first + 1, v.first.last, v.last)
      }
    }
  end
end

ans = Euler081.new.solve
#$stderr.puts "ans = #{ans}"
ans.each {|v| puts v.last; break }
