require 'set'

module Enumerable
  
  def collectf(fun)
    collect {|v| v.send(fun)}
  end
  
  def char_codes_to_set
    Set.new(collectf(:ord))
  end
end

class Array
  def collect_nth(n, off)
    (off ... size).collect {|i| ((i - off) % n == 0) ? (block_given? ? yield(self[i]) : self[i]) : nil }.compact
  end
end
       
class Decypher
  
  attr_reader :key, :str, :original_str
  
  VALID_OUTPUT_CHARS = [('a'..'z'), ('A'..'Z'), ('0'..'9'), "(;:,.'?-!) ".chars].collectf(:char_codes_to_set).sum(Set.new)
  
  def find_valid_key(str, off)
    ('a'..'z').collectf(:ord).each {|cc|
      return cc if str.collect_nth(3, off).all? {|c| VALID_OUTPUT_CHARS.include?(c ^ cc) }
    }
  end
  
  def find_key(str)
#    return "abc".chars.collectf(:ord) # DEBUG
    (0..2).collect {|off| find_valid_key(str, off) }
  end
  
  def decypher(str)
    str.collect.with_index {|c, i| c ^ key[i % key.size ] }
  end
  
  def initialize(str)
    @original_str, @key = str, find_key(str)
    @str = decypher(str)
  end
end

n = readline.to_i
str = readline.split(' ').map {|v| v.to_i }
d = Decypher.new(str)

#$stderr.puts("Decyphered: '#{d.str.collectf(:chr).join('') }'")
puts d.key.collectf(:chr).join('')
