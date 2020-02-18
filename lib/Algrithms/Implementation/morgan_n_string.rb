# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Array
  def first=(v)
    self[0] = v
  end
  
  def last=(v)
    self[-1] = v
  end
end

class Range
  def continued_by?(other)
    include?(other.first.pred) && !include?(other.first)
  end
  
  def join(other)
    return nil unless continued_by?(other)
    other.exclude_end? ? (first ... other.last) : (first .. other.last)
  end
end

class ArrayOfRanges < Array
  
  alias _put <<
  
  def <<(elem)
    if empty? || (!empty? && last.first != elem.first) then
      _put(elem)
    else
      j = last.last.join(elem.last)
      if j.nil? then
        _put(elem)
      else
        last.last = j
      end
    end
  end
end

class MorganNString
  attr_reader :ab
  
  def initialize(ab)
    @ab = ab
  end
  
#  def compare_ab(i, j)
#    return 0 if j >= ab.last.size
#    return 1 if i >= ab.first.size
#    return 0 if ab.first[i] < ab.last[j]
#    return 1 if ab.first[i] > ab.last[j]
#    ((ab[0][i..-1] < ab[1][j..-1]) ? 0 : 1)
#  end
  
  def solve
    ans, ij = ArrayOfRanges.new, [0, 0]
    while ((0..1).any? {|dx| ij[dx] < ab[dx].size }) do
      if (0..1).any? {|dx| ij[dx] >= ab[dx].size} then
        odx = ((ij.first >= ab.first.size) ? 1 : 0)
        return (ans << [odx, (ij[odx]..-1)])
      end
      
      case ab.first[ij.first] <=> ab.last[ij.last]
        when 1
          ans << [1, (ij.last..ij.last)]
          ij.last += 1
        when -1
          ans << [0, (ij.first..ij.first)]
          ij.first += 1
        when 0
          # TODO this should be optimized, too
          if ab.first[ij.first..-1] < ab.last[ij.last..-1] then
              ans << [0, (ij.first..ij.first)]
              ij.first += 1
          else
              ans << [1, (ij.last..ij.last)]
              ij.last += 1
          end
      end
    end
    ans
  end
end

class File
  def self.open_with_default(name, mode, dflt)
    begin
      File.open(name, mode)
    rescue => e
      dflt
    end  
  end
end

fout = File.open_with_default(ENV['OUTPUT_PATH'], 'w', $stdout)
fin =  File.open_with_default(ENV['INPUT_PATH'], 'r', $stdin)

t = fin.gets.strip.to_i

t.times {|test_no|
    # $stderr.puts "Test #{test_no}"
    ab = 2.times.collect {|_| fin.gets.strip }
    # $stderr.puts "A, B = '#{ab.first}' '#{ab.last}'"
    ans = MorganNString.new(ab).solve
    # $stderr.puts "ans = '#{ans}'"
    fout.puts ans.collect {|i| ab[i.first][i.last] }.join('')
}

fout.close
