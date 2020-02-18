
class BinaryIndexedTree
  attr_reader :bit
  
  def initialize(n, a = [])
    @bit = Array.new(n + 1, 0)
    $stderr.puts "before update bit = #{bit}"
    a.each_with_index {|v, i| update(i+1, v) }
    $stderr.puts "after update bit = #{bit}"
  end

  def query(i)
    return 0 if i <= 0
    sum = 0
    sum += bit[i] while (i -= (i & (-i))) > 0
    sum
  end
  
  def update(i, v)
    $stderr.puts "update(#{i}, #{v}):"
    begin $stderr.puts "    i=#{i}"; bit[i] += v; end while (i += (i & (-i))) < bit.size
  end
end

if __FILE__ == $0 then
  def read_int_array
    readline.strip.split(' ').collect(&:to_i)
  end
  
  def read_int
    readline.strip.to_i
  end
  n = read_int
  a = read_int_array
  bit = BinaryIndexedTree.new(n, a)
  
  q = read_int
  q.times {
    qs = readline.strip.split(' ')
    $stderr.puts "Query: #{qs.join(' ')}"
    x, y = qs[1..2].collect(&:to_i)
    case qs.first
    when 'C'
      puts bit.query(y) - bit.query(x - 1)
    when 'U'
      bit.update(x, y)
    end
  }
end
