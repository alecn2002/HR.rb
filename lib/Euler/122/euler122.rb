# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require 'set'

class Euler122
  attr_reader :seq
  
  def initialize(max_k)
    $stderr.puts "Euler122#initialize(#{max_k})"
    @seq = [0, 0]
    new = Set.new([1])
    until new.empty? do
      $stderr.puts "new=#{new}"
      max_new = new.max
      newnew = new.inject(Set.new) {|r, v|
        (1..max_new).inject(r) {|rr, vv|
          new_d = [seq[v], seq[vv]].max + 1
          new_v = v + vv
          if (new_v <= max_k && (seq[new_v].nil? || seq[new_v] > new_d)) then
            @seq[new_v] = new_d
            rr.add(new_v)
          end
          rr
        }
      }
      new = newnew
    end
    $stderr.puts "seq=#{seq.collect.with_index {|v, i| "#{i}=>#{v}"}.join(', ')}"
  end
end

t = readline.to_i
q = t.times.collect {|_| readline.to_i}

solver = Euler122.new(q.max)

q.each {|qv| puts solver.seq[qv] }
